import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import '../models/trip.dart';
import 'google_account_service.dart';
import 'sheet_rows.dart';

class SheetsSyncException implements Exception {
  SheetsSyncException(this.message);
  final String message;
  @override
  String toString() => message;
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
  static const spreadsheetTitle = '여행 경비';

  String _prefKey(String email) => 'spreadsheet_id:$email';

  Future<String?> spreadsheetUrl() async {
    final email = _account.account?.email;
    if (email == null) return null;
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_prefKey(email));
    return id == null ? null : 'https://docs.google.com/spreadsheets/d/$id';
  }

  /// 전체 데이터를 시트에 쓴다. 성공하면 시트 URL을 돌려준다.
  Future<String> sync(
    List<Trip> trips,
    List<Expense> expenses, {
    bool interactive = false,
  }) async {
    final email = _account.account?.email;
    if (email == null) throw SheetsSyncException('구글 계정에 로그인되어 있지 않습니다.');

    var client = await _account.authClient(interactive: interactive);
    if (client == null) {
      throw SheetsSyncException('구글 드라이브 권한이 필요합니다. 설정에서 다시 연결해 주세요.');
    }
    try {
      return await _syncWith(client, email, trips, expenses);
    } on sheets.DetailedApiRequestError catch (e) {
      if (e.status != 401) rethrow;
      // 토큰 만료: 한 번만 새 토큰으로 다시 시도한다.
      await _account.invalidateToken(client);
      client.close();
      client = await _account.authClient(interactive: interactive);
      if (client == null) {
        throw SheetsSyncException('구글 로그인이 만료되었습니다. 설정에서 다시 연결해 주세요.');
      }
      return await _syncWith(client, email, trips, expenses);
    } finally {
      client?.close();
    }
  }

  Future<String> _syncWith(
    gapis.AuthClient client,
    String email,
    List<Trip> trips,
    List<Expense> expenses,
  ) async {
    final sheetsApi = sheets.SheetsApi(client);
    final driveApi = drive.DriveApi(client);
    final id = await _ensureSpreadsheet(sheetsApi, driveApi, email);

    final values = sheetsApi.spreadsheets.values;
    await values.batchClear(
      sheets.BatchClearValuesRequest(
        ranges: SheetTabs.all.map(_tabRange).toList(),
      ),
      id,
    );
    await values.batchUpdate(
      sheets.BatchUpdateValuesRequest(
        valueInputOption: 'USER_ENTERED',
        data: [
          _range(SheetTabs.expenses, buildExpenseRows(trips, expenses)),
          _range(SheetTabs.trips, buildTripRows(trips, expenses)),
          _range(SheetTabs.summary, buildSummaryRows(trips, expenses)),
        ],
      ),
      id,
    );
    return 'https://docs.google.com/spreadsheets/d/$id';
  }

  String _tabRange(String tab) => "'$tab'";

  sheets.ValueRange _range(String tab, List<List<Object>> rows) =>
      sheets.ValueRange(range: "'$tab'!A1", values: rows);

  Future<String> _ensureSpreadsheet(
    sheets.SheetsApi sheetsApi,
    drive.DriveApi driveApi,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_prefKey(email));

    if (id != null) {
      try {
        await _ensureTabs(sheetsApi, id);
        return id;
      } on sheets.DetailedApiRequestError catch (e) {
        // 사용자가 시트를 지웠거나 휴지통에 넣은 경우: 새로 찾거나 만든다.
        if (e.status != 404 && e.status != 403) rethrow;
        await prefs.remove(_prefKey(email));
        id = null;
      }
    }

    id = await _findExisting(driveApi) ?? await _create(sheetsApi, driveApi);
    await _ensureTabs(sheetsApi, id);
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
  ) async {
    final created = await sheetsApi.spreadsheets.create(
      sheets.Spreadsheet(
        properties: sheets.SpreadsheetProperties(
          title: spreadsheetTitle,
          locale: 'ko_KR',
        ),
        sheets: [for (final tab in SheetTabs.all) _newTab(tab)],
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

  sheets.Sheet _newTab(String title) => sheets.Sheet(
    properties: sheets.SheetProperties(
      title: title,
      gridProperties: sheets.GridProperties(frozenRowCount: 1),
    ),
  );

  /// 사용자가 탭 이름을 바꾸거나 지웠으면 빠진 탭을 다시 만든다.
  Future<void> _ensureTabs(sheets.SheetsApi api, String id) async {
    final ss = await api.spreadsheets.get(
      id,
      $fields: 'sheets.properties.title',
    );
    final existing =
        ss.sheets
            ?.map((s) => s.properties?.title)
            .whereType<String>()
            .toSet() ??
        {};
    final missing = SheetTabs.all.where((t) => !existing.contains(t)).toList();
    if (missing.isEmpty) return;
    await api.spreadsheets.batchUpdate(
      sheets.BatchUpdateSpreadsheetRequest(
        requests: [
          for (final tab in missing)
            sheets.Request(
              addSheet: sheets.AddSheetRequest(
                properties: _newTab(tab).properties,
              ),
            ),
        ],
      ),
      id,
    );
  }
}
