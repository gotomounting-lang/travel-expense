import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import 'google_account_service.dart';
import 'sheet_rows.dart';

enum SheetsSyncError { notSignedIn, noPermission, expired }

class SheetsSyncException implements Exception {
  SheetsSyncException(this.reason);
  final SheetsSyncError reason;
  @override
  String toString() => 'SheetsSyncException(${reason.name})';
}

/// 사용자 본인 구글 드라이브의 `여행 경비` 스프레드시트에 기기 데이터를 반영한다.
///
/// 시트는 로그인한 계정마다 따로 만들어지고, 그 ID는 계정 이메일별로
/// 이 기기에만 저장된다. 앱을 다시 설치하면 drive.file 권한 안에서
/// 앱이 예전에 만든 시트를 찾아 이어서 쓴다.
///
/// 기기 데이터가 원본이고 시트는 사본이다. 동기화할 때마다 각 탭을
/// 통째로 다시 쓰므로 수정·삭제도 그대로 반영된다.
class SheetsSyncService {
  SheetsSyncService(this._account);

  final GoogleAccountService _account;

  static const _appPropKey = 'travelExpenseApp';
  static const _appPropValue = 'v1';

  String _prefKey(String email) => 'spreadsheet_id:$email';

  Future<String?> spreadsheetUrl() async {
    final email = _account.account?.email;
    if (email == null) return null;
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_prefKey(email));
    return id == null ? null : 'https://docs.google.com/spreadsheets/d/$id';
  }

  /// 전체 데이터를 시트에 쓴다. 성공하면 시트 URL을 돌려준다.
  /// [l] 은 머리글·탭 이름·카테고리를 쓸 언어.
  Future<String> sync(
    AppLocalizations l,
    List<Trip> trips,
    List<Expense> expenses, {
    bool interactive = false,
  }) async {
    final email = _account.account?.email;
    if (email == null) throw SheetsSyncException(SheetsSyncError.notSignedIn);

    var client = await _account.authClient(interactive: interactive);
    if (client == null) {
      throw SheetsSyncException(SheetsSyncError.noPermission);
    }
    try {
      return await _syncWith(client, email, l, trips, expenses);
    } on sheets.DetailedApiRequestError catch (e) {
      if (e.status != 401) rethrow;
      // 토큰 만료: 한 번만 새 토큰으로 다시 시도한다.
      await _account.invalidateToken(client);
      client.close();
      client = await _account.authClient(interactive: interactive);
      if (client == null) {
        throw SheetsSyncException(SheetsSyncError.expired);
      }
      return await _syncWith(client, email, l, trips, expenses);
    } finally {
      client?.close();
    }
  }

  Future<String> _syncWith(
    gapis.AuthClient client,
    String email,
    AppLocalizations l,
    List<Trip> trips,
    List<Expense> expenses,
  ) async {
    final sheetsApi = sheets.SheetsApi(client);
    final driveApi = drive.DriveApi(client);
    final id = await _ensureSpreadsheet(sheetsApi, driveApi, email, l);

    final values = sheetsApi.spreadsheets.values;
    await values.batchClear(
      sheets.BatchClearValuesRequest(
        ranges: [for (final tab in SheetTab.values) _quote(tab.title(l))],
      ),
      id,
    );
    await values.batchUpdate(
      sheets.BatchUpdateValuesRequest(
        valueInputOption: 'USER_ENTERED',
        data: [
          _range(l, SheetTab.expenses, buildExpenseRows(l, trips, expenses)),
          _range(l, SheetTab.trips, buildTripRows(l, trips, expenses)),
          _range(l, SheetTab.summary, buildSummaryRows(l, trips, expenses)),
        ],
      ),
      id,
    );
    return 'https://docs.google.com/spreadsheets/d/$id';
  }

  String _quote(String title) => "'${title.replaceAll("'", "''")}'";

  sheets.ValueRange _range(
    AppLocalizations l,
    SheetTab tab,
    List<List<Object>> rows,
  ) => sheets.ValueRange(range: '${_quote(tab.title(l))}!A1', values: rows);

  Future<String> _ensureSpreadsheet(
    sheets.SheetsApi sheetsApi,
    drive.DriveApi driveApi,
    String email,
    AppLocalizations l,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_prefKey(email));

    if (id != null) {
      try {
        await _ensureTabs(sheetsApi, id, l);
        return id;
      } on sheets.DetailedApiRequestError catch (e) {
        // 사용자가 시트를 지웠거나 휴지통에 넣은 경우: 새로 찾거나 만든다.
        if (e.status != 404 && e.status != 403) rethrow;
        await prefs.remove(_prefKey(email));
        id = null;
      }
    }

    id = await _findExisting(driveApi) ?? await _create(sheetsApi, driveApi, l);
    await _ensureTabs(sheetsApi, id, l);
    await prefs.setString(_prefKey(email), id);
    return id;
  }

  Future<String?> _findExisting(drive.DriveApi driveApi) async {
    final list = await driveApi.files.list(
      q:
          "appProperties has { key='$_appPropKey' and value='$_appPropValue' } "
          "and mimeType='application/vnd.google-apps.spreadsheet' "
          'and trashed=false',
      orderBy: 'createdTime',
      $fields: 'files(id)',
      pageSize: 1,
    );
    return list.files?.firstOrNull?.id;
  }

  Future<String> _create(
    sheets.SheetsApi sheetsApi,
    drive.DriveApi driveApi,
    AppLocalizations l,
  ) async {
    final created = await sheetsApi.spreadsheets.create(
      sheets.Spreadsheet(
        properties: sheets.SpreadsheetProperties(
          title: l.sheetFileTitle,
          locale: l.localeName,
        ),
        sheets: [
          for (final tab in SheetTab.values)
            sheets.Sheet(properties: _tabProperties(l, tab)),
        ],
      ),
    );
    final id = created.spreadsheetId!;
    // 재설치 후에도 이 시트를 찾을 수 있도록 표시를 남긴다.
    await driveApi.files.update(
      drive.File(appProperties: {_appPropKey: _appPropValue}),
      id,
    );
    return id;
  }

  sheets.SheetProperties _tabProperties(AppLocalizations l, SheetTab tab) =>
      sheets.SheetProperties(
        sheetId: tab.sheetId,
        title: tab.title(l),
        gridProperties: sheets.GridProperties(frozenRowCount: 1),
      );

  /// 탭을 sheetId 로 찾아, 사용자가 지운 탭은 다시 만들고 이름은 지금
  /// 언어에 맞춘다. 같은 이름의 다른 탭이 있으면 그 탭 이름을 피한다.
  Future<void> _ensureTabs(
    sheets.SheetsApi api,
    String id,
    AppLocalizations l,
  ) async {
    final ss = await api.spreadsheets.get(
      id,
      $fields: 'sheets.properties(sheetId,title)',
    );
    final byId = {
      for (final s in ss.sheets ?? <sheets.Sheet>[])
        if (s.properties?.sheetId != null)
          s.properties!.sheetId!: s.properties!,
    };
    final requests = <sheets.Request>[];
    for (final tab in SheetTab.values) {
      final want = tab.title(l);
      final current = byId[tab.sheetId];
      if (current?.title == want) continue;
      // 원하는 이름을 이미 다른 탭(사용자 탭 등)이 쓰고 있으면 그 탭 이름을 바꿔 둔다.
      final clash = byId.values.where(
        (p) => p.title == want && p.sheetId != tab.sheetId,
      );
      for (final other in clash) {
        requests.add(
          sheets.Request(
            updateSheetProperties: sheets.UpdateSheetPropertiesRequest(
              properties: sheets.SheetProperties(
                sheetId: other.sheetId,
                title: '$want (${other.sheetId})',
              ),
              fields: 'title',
            ),
          ),
        );
        other.title = '$want (${other.sheetId})';
      }
      if (current == null) {
        requests.add(
          sheets.Request(
            addSheet: sheets.AddSheetRequest(
              properties: _tabProperties(l, tab),
            ),
          ),
        );
      } else {
        requests.add(
          sheets.Request(
            updateSheetProperties: sheets.UpdateSheetPropertiesRequest(
              properties: sheets.SheetProperties(
                sheetId: tab.sheetId,
                title: want,
              ),
              fields: 'title',
            ),
          ),
        );
      }
    }
    if (requests.isEmpty) return;
    await api.spreadsheets.batchUpdate(
      sheets.BatchUpdateSpreadsheetRequest(requests: requests),
      id,
    );
  }
}
