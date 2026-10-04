import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../services/google_account_service.dart';
import 'nationality_screen.dart';

/// 처음 실행 1단계: 구글 계정 연결 (건너뛸 수 있음). 다음은 국적 선택.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _next(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NationalityScreen(onboarding: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final account = context.watch<GoogleAccountService>();
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.flight_takeoff,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l.welcomeTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                l.welcomeBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const Spacer(),
              if (account.isSignedIn)
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: Text(account.account!.email),
                ),
              if (account.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l.googleSignInError(account.error!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              if (account.isSignedIn)
                FilledButton(
                  onPressed: () => _next(context),
                  child: Text(l.next),
                )
              else ...[
                FilledButton.icon(
                  onPressed: () async {
                    if (await account.signIn() && context.mounted) {
                      _next(context);
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: Text(l.connectGoogle),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _next(context),
                  child: Text(l.skipForNow),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
