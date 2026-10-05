import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:travel_expense/l10n/app_localizations.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/services/sheet_rows.dart';
import 'package:travel_expense/services/sheets_sync_service.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('ko'));

  test('탭이 이미 다 맞으면 빈 변경 요청을 보내지 않는다 (400 오류 방지)', () async {
    final posts = <String>[];
    final api = sheets.SheetsApi(
      MockClient((req) async {
        if (req.method != 'GET') {
          posts.add(req.url.path);
          return http.Response('{}', 200);
        }
        return http.Response(
          jsonEncode({
            'sheets': [
              for (final tab in SheetTab.values)
                {
                  'properties': {'sheetId': tab.sheetId, 'title': tab.title(l)},
                },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await SheetsSyncService.ensureTabs(api, 'id', l);
    expect(posts, isEmpty);
  });

  test('없는 탭은 추가한다', () async {
    final bodies = <String>[];
    final api = sheets.SheetsApi(
      MockClient((req) async {
        if (req.method != 'GET') {
          bodies.add(req.body);
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({'sheets': <Object>[]}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await SheetsSyncService.ensureTabs(api, 'id', l);
    expect(bodies, hasLength(1));
    expect(bodies.single, contains('addSheet'));
  });

  test('여행별 시트: 예전에 만든 여행 탭은 지우고 요약·내역 탭만 둔다', () async {
    final bodies = <String>[];
    final api = sheets.SheetsApi(
      MockClient((req) async {
        if (req.method != 'GET') {
          bodies.add(req.body);
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'sheets': [
              for (final tab in SheetTab.values)
                {
                  'properties': {'sheetId': tab.sheetId, 'title': tab.title(l)},
                },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    await SheetsSyncService.ensureTabs(
      api,
      'id',
      l,
      tabs: const [SheetTab.summary, SheetTab.expenses],
    );
    expect(bodies, hasLength(1));
    final requests = jsonDecode(bodies.single)['requests'] as List;
    expect(requests, [
      {
        'deleteSheet': {'sheetId': SheetTab.trips.sheetId},
      },
    ]);
  });

  test('여행별 시트 파이차트 색: 강조색을 앱 카테고리 색으로, 조각 순서대로', () {
    final json = jsonDecode(
      jsonEncode(
        SheetsSyncService.themeFor([
          ExpenseCategory.shopping,
          ExpenseCategory.food,
        ]).toJson(),
      ),
    );
    final colors = {
      for (final p
          in json['updateSpreadsheetProperties']['properties']['spreadsheetTheme']['themeColors']
              as List)
        p['colorType']: p['color']['rgbColor'],
    };
    expect(colors.keys, containsAll(['TEXT', 'BACKGROUND', 'LINK']));
    expect(colors.keys.where((k) => k.startsWith('ACCENT')), hasLength(6));
    Map<String, double> rgb(ExpenseCategory c) => {
      'red': c.color.r,
      'green': c.color.g,
      'blue': c.color.b,
    };
    expect(colors['ACCENT1'], rgb(ExpenseCategory.shopping));
    expect(colors['ACCENT2'], rgb(ExpenseCategory.food));
    expect(colors['ACCENT3'], rgb(ExpenseCategory.snack));
  });
}
