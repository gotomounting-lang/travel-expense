import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;

/// 사용자 본인의 구글 계정 로그인.
///
/// 각 사용자는 자기 구글 계정으로 로그인하고, 앱은 그 계정의 드라이브에서
/// **앱이 직접 만든 파일만** 다룰 수 있는 `drive.file` 권한만 요청한다.
/// 사용자의 다른 파일이나 다른 사용자의 데이터에는 접근하지 않는다.
class GoogleAccountService extends ChangeNotifier {
  GoogleAccountService({this.serverClientId});

  /// Google Cloud 콘솔의 "웹 애플리케이션" OAuth 클라이언트 ID.
  /// 안드로이드 로그인에 필요하며 빌드할 때 --dart-define 으로 넣는다.
  final String? serverClientId;

  static const scopes = [drive.DriveApi.driveFileScope];

  final _signIn = GoogleSignIn.instance;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _sub;

  GoogleSignInAccount? _account;
  GoogleSignInAccount? get account => _account;
  bool get isSignedIn => _account != null;

  String? _error;
  String? get error => _error;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      await _signIn.initialize(serverClientId: serverClientId);
      _sub = _signIn.authenticationEvents.listen(
        _onEvent,
        onError: (Object e) {
          if (e is GoogleSignInException &&
              e.code == GoogleSignInExceptionCode.canceled) {
            return;
          }
          _error = _describe(e);
          notifyListeners();
        },
      );
      await _signIn.attemptLightweightAuthentication();
    } catch (e) {
      _error = _describe(e);
      notifyListeners();
    }
  }

  void _onEvent(GoogleSignInAuthenticationEvent event) {
    _account = switch (event) {
      GoogleSignInAuthenticationEventSignIn(:final user) => user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
    _error = null;
    notifyListeners();
  }

  /// 로그인 버튼에서 호출. 로그인과 드라이브 권한 동의를 한 번에 받는다.
  Future<bool> signIn() async {
    try {
      final user = await _signIn.authenticate(scopeHint: scopes);
      await user.authorizationClient.authorizeScopes(scopes);
      _account = user;
      _error = null;
      notifyListeners();
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) {
        _error = _describe(e);
        notifyListeners();
      }
      return false;
    } catch (e) {
      _error = _describe(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _signIn.disconnect();
    _account = null;
    notifyListeners();
  }

  /// 구글 API 호출용 클라이언트. 이미 동의한 권한이 없으면 null
  /// (자동 동기화 중에는 사용자에게 창을 띄우지 않는다).
  Future<gapis.AuthClient?> authClient({bool interactive = false}) async {
    final user = _account;
    if (user == null) return null;
    var auth = await user.authorizationClient.authorizationForScopes(scopes);
    if (auth == null && interactive) {
      auth = await user.authorizationClient.authorizeScopes(scopes);
    }
    return auth?.authClient(scopes: scopes);
  }

  /// 토큰이 만료되어 401을 받았을 때 캐시된 토큰을 버린다.
  Future<void> invalidateToken(gapis.AuthClient client) async {
    final token = client.credentials.accessToken.data;
    await _account?.authorizationClient.clearAuthorizationToken(
      accessToken: token,
    );
  }

  /// 화면에서 언어별 문구로 감싸 보여줄 오류 내용.
  String _describe(Object e) => e is GoogleSignInException
      ? '${e.code.name} ${e.description ?? ''}'.trim()
      : '$e';

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
