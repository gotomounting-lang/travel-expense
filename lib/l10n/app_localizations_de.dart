// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Einstellungen';

  @override
  String get newTrip => 'Neue Reise';

  @override
  String get editTrip => 'Reise bearbeiten';

  @override
  String get deleteTrip => 'Reise löschen';

  @override
  String get tripTitle => 'Reisename';

  @override
  String get tripTitleHint => 'z. B. Familienreise Tokio 2026';

  @override
  String get tripTitleRequired => 'Bitte gib einen Reisenamen ein';

  @override
  String get countryOptional => 'Land/Stadt (optional)';

  @override
  String get countryHint => 'z. B. Tokio, Japan';

  @override
  String get localCurrency => 'Landeswährung';

  @override
  String get currency => 'Währung';

  @override
  String get tripPeriod => 'Reisezeitraum';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteTripConfirmTitle => 'Diese Reise löschen?';

  @override
  String get deleteTripConfirmBody =>
      'Alle Ausgaben dieser Reise werden gelöscht und bei der nächsten Synchronisierung aus deiner Tabelle entfernt.';

  @override
  String get totalSpent => 'Gesamtausgaben';

  @override
  String pendingRates(int count) {
    return '$count warten auf Wechselkurs (online nach unten ziehen zum Aktualisieren)';
  }

  @override
  String get firstExpenseHint =>
      'Tippe auf +, um deine erste Ausgabe zu erfassen';

  @override
  String get addExpense => 'Ausgabe hinzufügen';

  @override
  String get editExpense => 'Ausgabe bearbeiten';

  @override
  String get ratePending => 'Kurs ausstehend';

  @override
  String get amount => 'Betrag';

  @override
  String get amountRequired => 'Bitte gib einen Betrag ein';

  @override
  String get category => 'Kategorie';

  @override
  String get merchantOptional => 'Händler (optional)';

  @override
  String get merchantHint => 'z. B. Ichiran Ramen';

  @override
  String get paymentOptional => 'Zahlungsart (optional)';

  @override
  String get paymentHint => 'z. B. Visa-Karte, bar';

  @override
  String get memoOptional => 'Notiz (optional)';

  @override
  String get checkingRate => 'Wechselkurs wird geprüft…';

  @override
  String get rateUnavailable =>
      'Der Wechselkurs ist gerade nicht verfügbar. Speichere die Ausgabe – wir rechnen sie um, sobald du online bist.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (Stand: $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausgaben',
      one: '1 Ausgabe',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Erstelle deine erste Reise';

  @override
  String get emptyBody =>
      'Wir rechnen deine Ausgaben im Ausland zum Kurs des Zahlungstags in deine Heimatwährung um\nund speichern sie in deiner eigenen Google-Tabelle.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Melde dich mit deinem Google-Konto an, dann wird in deinem Google Drive die Tabelle „$fileName“ erstellt und bei jeder erfassten Ausgabe aktualisiert. Die App hat nur Zugriff auf die von ihr erstellte Tabelle, und deine Daten werden nie an unsere Server gesendet.';
  }

  @override
  String get connectGoogle => 'Google-Konto verbinden';

  @override
  String get syncNow => 'Jetzt speichern';

  @override
  String get openSheet => 'Tabelle öffnen';

  @override
  String get disconnect => 'Trennen';

  @override
  String get rateInfoTitle => 'Zu den Wechselkursen';

  @override
  String get rateInfoBody =>
      'Beträge in deiner Heimatwährung basieren auf dem Referenzkurs des Zahlungstags (Europäische Zentralbank bzw. öffentliche Kursdaten für andere Währungen). An Wochenenden und Feiertagen gilt der Kurs des vorherigen Werktags. Deine tatsächliche Kartenabrechnung kann wegen Kurs und Gebühren des Kartenanbieters leicht abweichen.';

  @override
  String googleSignInError(String details) {
    return 'Fehler bei der Google-Anmeldung: $details';
  }

  @override
  String get syncSaved => 'In Tabelle gespeichert';

  @override
  String syncFailed(String details) {
    return 'Speichern in Tabelle fehlgeschlagen: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Du bist nicht bei Google angemeldet.';

  @override
  String get syncErrorNoPermission =>
      'Zugriff auf Google Drive erforderlich. Bitte verbinde dich erneut.';

  @override
  String get syncErrorExpired =>
      'Deine Google-Anmeldung ist abgelaufen. Bitte verbinde dich erneut.';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Automatisch (nach Nationalität)';

  @override
  String get catFood => 'Essen';

  @override
  String get catSnack => 'Snacks/Café';

  @override
  String get catSouvenir => 'Souvenirs';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTransport => 'Verkehr';

  @override
  String get catLodging => 'Unterkunft';

  @override
  String get catSightseeing => 'Sightseeing';

  @override
  String get catOther => 'Sonstiges';

  @override
  String get sourceManual => 'Manuell';

  @override
  String get sourceReceipt => 'Beleg';

  @override
  String get sourceCard => 'Kartenmitteilung';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Ausgaben';

  @override
  String get tabTrips => 'Reisen';

  @override
  String get tabSummary => 'Übersicht';

  @override
  String get colTrip => 'Reise';

  @override
  String get colDate => 'Datum';

  @override
  String get colTime => 'Uhrzeit';

  @override
  String get colCategory => 'Kategorie';

  @override
  String get colMerchant => 'Händler';

  @override
  String get colCurrency => 'Währung';

  @override
  String get colLocalAmount => 'Betrag lokal';

  @override
  String get colRateDate => 'Kursdatum';

  @override
  String get colPayment => 'Zahlung';

  @override
  String get colSource => 'Quelle';

  @override
  String get colMemo => 'Notiz';

  @override
  String get colRateSource => 'Kursquelle';

  @override
  String get colCountry => 'Land';

  @override
  String get colStartDate => 'Beginn';

  @override
  String get colEndDate => 'Ende';

  @override
  String get colCount => 'Anzahl';

  @override
  String get colShare => 'Anteil (%)';

  @override
  String get scanReceipt => 'Beleg scannen';

  @override
  String get pickReceipt => 'Beleg aus Fotos';

  @override
  String get enterManually => 'Manuell eingeben';

  @override
  String get readingReceipt => 'Beleg wird gelesen…';

  @override
  String get receiptReadNotice =>
      'Aus deinem Beleg ausgefüllt. Bitte vor dem Speichern prüfen und korrigieren. Das Foto wurde nach der Analyse gelöscht.';

  @override
  String get receiptNothingFound =>
      'Auf dem Beleg wurde kein Betrag gefunden. Bitte gib ihn manuell ein. Das Foto wurde gelöscht.';

  @override
  String receiptScanFailed(String details) {
    return 'Beleg konnte nicht gelesen werden: $details';
  }

  @override
  String get photoDeletedNote =>
      'Fotos werden auf deinem Gerät analysiert und sofort gelöscht. Sie werden nie gespeichert oder hochgeladen.';

  @override
  String get cardAlertsSection => 'Kartenzahlungen automatisch erfassen';

  @override
  String get cardAlertsBody =>
      'Wenn du im Ausland mit Karte zahlst, wird die Freigabemitteilung deiner Karten-App (oder deines Messengers) gelesen und in der Reise für dieses Datum erfasst. Nur Freigaben in Fremdwährung werden verarbeitet, und zwar auf deinem Gerät. Andere Benachrichtigungen werden nie gespeichert oder weitergegeben.';

  @override
  String get cardAlertsOn => 'An';

  @override
  String get cardAlertsOff => 'Aus (Benachrichtigungszugriff nötig)';

  @override
  String get cardAlertsAllow => 'Benachrichtigungszugriff erlauben';

  @override
  String get cardAlertsSettings =>
      'Einstellungen für Benachrichtigungszugriff öffnen';

  @override
  String get cardAlertsConsentTitle => 'Zum Benachrichtigungszugriff';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Erlaube auf dem nächsten Bildschirm den Benachrichtigungszugriff für „$appName“. Die App filtert aus deinen Benachrichtigungen nur Freigaben von Kartenzahlungen im Ausland heraus und erfasst sie als Ausgaben. Benachrichtigungsinhalte verlassen nie dein Gerät, und du kannst dies jederzeit in derselben Einstellung deaktivieren.';
  }

  @override
  String get agreeAndContinue => 'Zustimmen und weiter';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kartenzahlungen warten',
      one: '1 Kartenzahlung wartet',
    );
    return '$_temp0 auf eine Reise, die das Zahlungsdatum abdeckt. Erstelle diese Reise, dann werden sie automatisch hinzugefügt.';
  }

  @override
  String get pasteCardAlert => 'Kartenmitteilung einfügen';

  @override
  String get pasteCardAlertHint =>
      'Füge die Freigabemitteilung aus deiner Karten-App oder SMS ein.';

  @override
  String get pasteCardAlertFailed =>
      'Das konnte nicht als Freigabe einer Auslandszahlung erkannt werden. Bitte gib es manuell ein.';

  @override
  String get cardReadNotice =>
      'Aus deiner Kartenmitteilung ausgefüllt. Bitte vor dem Speichern prüfen und korrigieren.';

  @override
  String get read => 'Lesen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String colHomeRate(String currency) {
    return 'Kurs ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Betrag ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Summe ($currency)';
  }

  @override
  String get noConvertedYet => 'Noch keine umgerechneten Ausgaben';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Nationalität';

  @override
  String get chooseNationality => 'Wähle deine Nationalität';

  @override
  String get nationalityBody =>
      'Alle Ausgaben werden in die Währung deines Landes umgerechnet, und die App-Sprache wird angepasst. Du kannst das später in den Einstellungen ändern.';

  @override
  String get searchCountry => 'Land suchen';

  @override
  String get homeCurrency => 'Heimatwährung';

  @override
  String get welcomeTitle => 'Willkommen bei Travel Expense';

  @override
  String get welcomeBody =>
      'Verbinde dein Google-Konto, um deine Ausgaben automatisch in einer Tabelle in deinem eigenen Google Drive zu speichern.';

  @override
  String get skipForNow => 'Später';

  @override
  String get next => 'Weiter';

  @override
  String get exportTripSheet => 'In Google Tabellen speichern';

  @override
  String get exportTripSheetSaving => 'Wird in Google Tabellen gespeichert…';

  @override
  String exportTripSheetDone(String title) {
    return 'In der Tabelle „$title“ gespeichert';
  }

  @override
  String get receiptTotalNotFound =>
      'Der Gesamtbetrag auf dem Beleg konnte nicht erkannt werden. Bitte Betrag und Währung selbst eingeben. Das Foto wurde nach der Analyse gelöscht.';

  @override
  String get receiptCurrencyNotFound =>
      'Die Währung auf dem Beleg konnte nicht erkannt werden. Bitte Betrag prüfen und Währung selbst wählen. Das Foto wurde nach der Analyse gelöscht.';

  @override
  String get currencyRequired => 'Bitte Währung wählen';

  @override
  String batchTitle(int count) {
    return '$count Zahlungen erkannt';
  }

  @override
  String get batchHint =>
      'Wähle aus, was gespeichert wird. Tippe auf einen Betrag, um ihn zu ändern.';

  @override
  String batchSave(int count) {
    return '$count ausgewählte speichern';
  }

  @override
  String batchSaved(int count) {
    return '$count Ausgaben gespeichert';
  }

  @override
  String get batchOutsideTrip => 'Außerhalb der Reisedaten';

  @override
  String get batchDuplicate => 'Bereits gespeichert';

  @override
  String get batchNeedsInput => 'Betrag/Währung prüfen · Betrag antippen';

  @override
  String get scanIncomplete =>
      'Einige Zahlungen konnten nicht gelesen werden. Bitte jede Zahlung einzeln eingeben.';
}
