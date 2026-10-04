import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:travel_expense/l10n/app_localizations.dart';
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
}
