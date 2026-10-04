import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../services/google_account_service.dart';
import '../../services/sheets_sync_service.dart';
import '../../state/app_state.dart';
import '../../state/locale_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final account = context.watch<GoogleAccountService>();
    final theme = Theme.of(context);
    final user = account.account;
    final l = AppLocalizations.of(context);
    final locale = context.watch<LocaleController>();

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.language, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            initialValue: locale.choice,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: null, child: Text(l.languageSystem)),
              for (final code in LocaleController.supported)
                DropdownMenuItem(
                  value: code,
                  child: Text(LocaleController.nativeNames[code]!),
                ),
            ],
            onChanged: locale.choose,
          ),
          const Divider(height: 40),
          Text(l.googleSheetsSection, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            l.googleSheetsBody(l.sheetFileTitle),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (user == null)
            FilledButton.icon(
              onPressed: () => account.signIn(),
              icon: const Icon(Icons.login),
              label: Text(l.connectGoogle),
            )
          else ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: user.photoUrl == null
                    ? null
                    : NetworkImage(user.photoUrl!),
                child: user.photoUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(user.displayName ?? user.email),
              subtitle: Text(user.email),
            ),
            if (_syncText(l, state) case final text?)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: state.syncStatus == SyncStatus.failed
                        ? theme.colorScheme.error
                        : null,
                  ),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: state.syncStatus == SyncStatus.syncing
                      ? null
                      : () => state.syncNow(interactive: true),
                  icon: state.syncStatus == SyncStatus.syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: Text(l.syncNow),
                ),
                if (state.sheetUrl != null)
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(state.sheetUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(l.openSheet),
                  ),
                TextButton(
                  onPressed: () => account.signOut(),
                  child: Text(l.disconnect),
                ),
              ],
            ),
          ],
          if (account.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l.googleSignInError(account.error!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          const Divider(height: 40),
          Text(l.rateInfoTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l.rateInfoBody, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

String? _syncText(AppLocalizations l, AppState state) {
  switch (state.syncStatus) {
    case SyncStatus.ok:
      return l.syncSaved;
    case SyncStatus.failed:
      final e = state.syncError;
      final details = e is SheetsSyncException
          ? switch (e.reason) {
              SheetsSyncError.notSignedIn => l.syncErrorNotSignedIn,
              SheetsSyncError.noPermission => l.syncErrorNoPermission,
              SheetsSyncError.expired => l.syncErrorExpired,
            }
          : '$e';
      return l.syncFailed(details);
    case SyncStatus.idle:
    case SyncStatus.syncing:
      return null;
  }
}
