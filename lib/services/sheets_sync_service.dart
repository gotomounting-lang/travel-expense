import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import 'google_account_service.dart';
import '../util/money.dart';
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
    String home,
    List<Trip> trips,
    List<Expense> expenses, {
    bool interactive = false,
  }) async {
    final email = _account.account?.email;
    if (email == null) throw SheetsSyncException(SheetsSyncError.notSignedIn);

    return _withClient(interactive, (client) async {
      final url = await _syncWith(
        client,
        l,
        home,
        trips,
        expenses,
        _Target(
          prefKey: _prefKey(email),
          appPropValue: _appPropValue,
          title: l.sheetFileTitle,
          // 사용자가 바꾼 이름을 존중한다.
          renameToTitle: false,
        ),
      );
      // "구글 시트로 저장"으로 한 번 만든 여행별 시트도 함께 최신으로 맞춘다.
      final prefs = await SharedPreferences.getInstance();
      for (final trip in trips) {
        final target = _tripTarget(email, trip);
        if (prefs.getString(target.prefKey) == null) continue;
        try {
          await _syncWith(
            client,
            l,
            home,
            [trip],
            [
              for (final e in expenses)
                if (e.tripId == trip.id) e,
            ],
            target,
          );
        } catch (e) {
          debugPrint('trip sheet sync failed (${trip.id}): $e');
        }
      }
      return url;
    });
  }

  _Target _tripTarget(String email, Trip trip) => _Target(
    prefKey: 'trip_spreadsheet_id:$email:${trip.id}',
    appPropValue: 'trip:${trip.id}',
    title: trip.title,
    // 여행이 하나뿐이라 여행 탭은 한 줄짜리가 되므로 두지 않는다.
    tabs: const [SheetTab.summary, SheetTab.expenses],
  );

  /// 여행 하나의 지출을 그 여행 이름의 스프레드시트에 따로 저장한다.
  /// 같은 여행은 같은 시트를 다시 쓰고, 여행 이름이 바뀌면 시트 이름도 바꾼다.
  Future<String> exportTrip(
    AppLocalizations l,
    String home,
    Trip trip,
    List<Expense> expenses,
  ) async {
    final email = _account.account?.email;
    if (email == null) throw SheetsSyncException(SheetsSyncError.notSignedIn);
    return _withClient(
      true,
      (client) => _syncWith(
        client,
        l,
        home,
        [trip],
        [
          for (final e in expenses)
            if (e.tripId == trip.id) e,
        ],
        _tripTarget(email, trip),
      ),
    );
  }

  /// 인증한 클라이언트로 [run] 을 실행한다. 토큰이 만료됐으면 한 번 다시 시도한다.
  Future<String> _withClient(
    bool interactive,
    Future<String> Function(gapis.AuthClient client) run,
  ) async {
    var client = await _account.authClient(interactive: interactive);
    if (client == null) {
      throw SheetsSyncException(SheetsSyncError.noPermission);
    }
    try {
      return await run(client);
    } on sheets.DetailedApiRequestError catch (e) {
      if (e.status != 401) rethrow;
      await _account.invalidateToken(client);
      client.close();
      client = await _account.authClient(interactive: interactive);
      if (client == null) {
        throw SheetsSyncException(SheetsSyncError.expired);
      }
      return await run(client);
    } finally {
      client?.close();
    }
  }

  Future<String> _syncWith(
    gapis.AuthClient client,
    AppLocalizations l,
    String home,
    List<Trip> trips,
    List<Expense> expenses,
    _Target target,
  ) async {
    final sheetsApi = sheets.SheetsApi(client);
    final driveApi = drive.DriveApi(client);
    final id = await _ensureSpreadsheet(sheetsApi, driveApi, l, target);

    final summary = buildSummary(l, home, trips, expenses);
    final values = sheetsApi.spreadsheets.values;
    await values.batchClear(
      sheets.BatchClearValuesRequest(
        ranges: [for (final tab in target.tabs) _quote(tab.title(l))],
      ),
      id,
    );
    await values.batchUpdate(
      sheets.BatchUpdateValuesRequest(
        valueInputOption: 'USER_ENTERED',
        data: [
          _range(
            l,
            SheetTab.expenses,
            buildExpenseRows(l, home, trips, expenses),
          ),
          if (target.tabs.contains(SheetTab.trips))
            _range(l, SheetTab.trips, buildTripRows(l, home, trips, expenses)),
          _range(l, SheetTab.summary, summary.rows),
        ],
      ),
      id,
    );
    await _replaceCharts(sheetsApi, id, l, home, summary.blocks, target.tabs);
    return 'https://docs.google.com/spreadsheets/d/$id';
  }

  /// 내역·여행 탭 행 높이를 맞추고, 요약 탭의 파이차트를 여행마다 하나씩 다시 그린다.
  /// (행 수가 바뀌므로 앱이 만든 요약 탭의 차트는 지우고 새로 만든다.)
  /// 시트를 열면 총액과 파이차트가 바로 보이게 요약 탭을 맨 앞에 둔다.
  Future<void> _replaceCharts(
    sheets.SheetsApi api,
    String id,
    AppLocalizations l,
    String home,
    List<SummaryBlock> blocks,
    List<SheetTab> tabs,
  ) async {
    final sheetId = SheetTab.summary.sheetId;
    final ss = await api.spreadsheets.get(
      id,
      $fields: 'sheets(properties(sheetId),charts(chartId))',
    );
    final existing = [
      for (final s in ss.sheets ?? <sheets.Sheet>[])
        if (s.properties?.sheetId == sheetId)
          for (final c in s.charts ?? <sheets.EmbeddedChart>[])
            if (c.chartId != null) c.chartId!,
    ];
    final requests = <sheets.Request>[
      sheets.Request(
        updateSheetProperties: sheets.UpdateSheetPropertiesRequest(
          properties: sheets.SheetProperties(sheetId: sheetId, index: 0),
          fields: 'index',
        ),
      ),
      // 예전에 여러 줄 메모로 늘어난 행 높이를 글자 한 줄 높이로 되돌린다.
      for (final tab in [SheetTab.expenses, SheetTab.trips])
        if (tabs.contains(tab))
          sheets.Request(
            updateDimensionProperties: sheets.UpdateDimensionPropertiesRequest(
              range: sheets.DimensionRange(
                sheetId: tab.sheetId,
                dimension: 'ROWS',
                startIndex: 0,
              ),
              properties: sheets.DimensionProperties(pixelSize: 21),
              fields: 'pixelSize',
            ),
          ),
      for (final chartId in existing)
        sheets.Request(
          deleteEmbeddedObject: sheets.DeleteEmbeddedObjectRequest(
            objectId: chartId,
          ),
        ),
      for (final (i, b) in blocks.indexed)
        sheets.Request(
          addChart: sheets.AddChartRequest(chart: _pie(l, home, b, i)),
        ),
    ];
    await api.spreadsheets.batchUpdate(
      sheets.BatchUpdateSpreadsheetRequest(requests: requests),
      id,
    );
  }

  sheets.EmbeddedChart _pie(
    AppLocalizations l,
    String home,
    SummaryBlock b,
    int index,
  ) {
    final sheetId = SheetTab.summary.sheetId;
    sheets.ChartData column(int col) => sheets.ChartData(
      sourceRange: sheets.ChartSourceRange(
        sources: [
          sheets.GridRange(
            sheetId: sheetId,
            startRowIndex: b.startRow,
            endRowIndex: b.endRow,
            startColumnIndex: col,
            endColumnIndex: col + 1,
          ),
        ],
      ),
    );
    return sheets.EmbeddedChart(
      spec: sheets.ChartSpec(
        title: '${b.title} · ${formatMoney(l, b.total, home)}',
        pieChart: sheets.PieChartSpec(
          legendPosition: 'RIGHT_LEGEND',
          pieHole: 0.4,
          domain: column(1), // 카테고리
          series: column(2), // 환산 합계
        ),
      ),
      position: sheets.EmbeddedObjectPosition(
        overlayPosition: sheets.OverlayPosition(
          anchorCell: sheets.GridCoordinate(
            sheetId: sheetId,
            rowIndex: index * 16,
            columnIndex: 5,
          ),
          widthPixels: 480,
          heightPixels: 300,
        ),
      ),
    );
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
    AppLocalizations l,
    _Target target,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(target.prefKey);

    if (id != null) {
      try {
        await ensureTabs(sheetsApi, id, l, tabs: target.tabs);
        if (target.renameToTitle) {
          await _ensureTitle(driveApi, id, target.title);
        }
        return id;
      } on sheets.DetailedApiRequestError catch (e) {
        // 사용자가 시트를 지웠거나 휴지통에 넣은 경우: 새로 찾거나 만든다.
        if (e.status != 404 && e.status != 403) rethrow;
        await prefs.remove(target.prefKey);
        id = null;
      }
    }

    final existing = await _findExisting(driveApi, target.appPropValue);
    id = existing ?? await _create(sheetsApi, driveApi, l, target);
    await ensureTabs(sheetsApi, id, l, tabs: target.tabs);
    if (existing != null && target.renameToTitle) {
      await _ensureTitle(driveApi, id, target.title);
    }
    await prefs.setString(target.prefKey, id);
    return id;
  }

  /// 여행 이름이 바뀌었으면 시트 파일 이름도 맞춘다.
  Future<void> _ensureTitle(
    drive.DriveApi driveApi,
    String id,
    String title,
  ) async {
    final file = await driveApi.files.get(id, $fields: 'name') as drive.File;
    if (file.name == title) return;
    await driveApi.files.update(drive.File(name: title), id);
  }

  Future<String?> _findExisting(
    drive.DriveApi driveApi,
    String appPropValue,
  ) async {
    final value = appPropValue.replaceAll("'", r"\'");
    final list = await driveApi.files.list(
      q:
          "appProperties has { key='$_appPropKey' and value='$value' } "
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
    _Target target,
  ) async {
    final created = await sheetsApi.spreadsheets.create(
      sheets.Spreadsheet(
        properties: sheets.SpreadsheetProperties(
          title: target.title,
          locale: l.localeName,
        ),
        sheets: [
          for (final tab in target.tabs)
            sheets.Sheet(properties: _tabProperties(l, tab)),
        ],
      ),
    );
    final id = created.spreadsheetId!;
    // 재설치 후에도 이 시트를 찾을 수 있도록 표시를 남긴다.
    await driveApi.files.update(
      drive.File(appProperties: {_appPropKey: target.appPropValue}),
      id,
    );
    return id;
  }

  static sheets.SheetProperties _tabProperties(
    AppLocalizations l,
    SheetTab tab,
  ) => sheets.SheetProperties(
    sheetId: tab.sheetId,
    title: tab.title(l),
    gridProperties: sheets.GridProperties(frozenRowCount: 1),
  );

  /// 탭을 sheetId 로 찾아, 사용자가 지운 탭은 다시 만들고 이름은 지금
  /// 언어에 맞춘다. 같은 이름의 다른 탭이 있으면 그 탭 이름을 피한다.
  @visibleForTesting
  static Future<void> ensureTabs(
    sheets.SheetsApi api,
    String id,
    AppLocalizations l, {
    List<SheetTab> tabs = SheetTab.values,
  }) async {
    final ss = await api.spreadsheets.get(
      id,
      $fields: 'sheets.properties(sheetId,title)',
    );
    final byId = {
      for (final s in ss.sheets ?? <sheets.Sheet>[])
        if (s.properties?.sheetId != null)
          s.properties!.sheetId!: s.properties!,
    };
    final requests = <sheets.Request>[
      // 이 시트에 두지 않는 앱 탭(예전 여행별 시트의 여행 탭)은 지운다.
      for (final tab in SheetTab.values)
        if (!tabs.contains(tab) && byId.containsKey(tab.sheetId))
          sheets.Request(
            deleteSheet: sheets.DeleteSheetRequest(sheetId: tab.sheetId),
          ),
    ];
    for (final tab in tabs) {
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
    // 탭이 이미 다 맞으면 보낼 것이 없다 (빈 요청은 시트 API 가 400 으로 거절한다).
    if (requests.isEmpty) return;
    await api.spreadsheets.batchUpdate(
      sheets.BatchUpdateSpreadsheetRequest(requests: requests),
      id,
    );
  }
}

/// 데이터를 쓸 스프레드시트: 이 기기에 저장한 ID 키, 드라이브에서 다시 찾을
/// 표시, 파일 이름.
class _Target {
  const _Target({
    required this.prefKey,
    required this.appPropValue,
    required this.title,
    this.renameToTitle = true,
    this.tabs = SheetTab.values,
  });

  final String prefKey;
  final String appPropValue;
  final String title;

  /// 파일 이름이 [title] 과 다르면 바꾼다 (여행 이름을 바꾼 경우).
  final bool renameToTitle;

  /// 이 시트에 두는 탭. 여행 하나짜리 시트에는 여행 탭이 필요 없다.
  final List<SheetTab> tabs;
}
