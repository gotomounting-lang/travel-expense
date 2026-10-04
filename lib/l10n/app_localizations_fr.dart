// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Paramètres';

  @override
  String get newTrip => 'Nouveau voyage';

  @override
  String get editTrip => 'Modifier le voyage';

  @override
  String get deleteTrip => 'Supprimer le voyage';

  @override
  String get tripTitle => 'Nom du voyage';

  @override
  String get tripTitleHint => 'ex. : Voyage en famille à Tokyo 2026';

  @override
  String get tripTitleRequired => 'Veuillez saisir un nom de voyage';

  @override
  String get countryOptional => 'Pays/ville (facultatif)';

  @override
  String get countryHint => 'ex. : Tokyo, Japon';

  @override
  String get localCurrency => 'Devise locale';

  @override
  String get currency => 'Devise';

  @override
  String get tripPeriod => 'Dates du voyage';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteTripConfirmTitle => 'Supprimer ce voyage ?';

  @override
  String get deleteTripConfirmBody =>
      'Toutes les dépenses de ce voyage seront supprimées et retirées de votre feuille lors de la prochaine synchronisation.';

  @override
  String get totalSpent => 'Total dépensé';

  @override
  String pendingRates(int count) {
    return '$count en attente du taux de change (tirez vers le bas pour actualiser une fois en ligne)';
  }

  @override
  String get firstExpenseHint =>
      'Appuyez sur + pour enregistrer votre première dépense';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get editExpense => 'Modifier la dépense';

  @override
  String get ratePending => 'Taux en attente';

  @override
  String get amount => 'Montant';

  @override
  String get amountRequired => 'Veuillez saisir un montant';

  @override
  String get category => 'Catégorie';

  @override
  String get merchantOptional => 'Commerçant (facultatif)';

  @override
  String get merchantHint => 'ex. : Ichiran Ramen';

  @override
  String get paymentOptional => 'Moyen de paiement (facultatif)';

  @override
  String get paymentHint => 'ex. : carte Visa, espèces';

  @override
  String get memoOptional => 'Note (facultatif)';

  @override
  String get checkingRate => 'Vérification du taux de change…';

  @override
  String get rateUnavailable =>
      'Impossible d\'obtenir le taux de change pour le moment. Enregistrez la dépense, nous la convertirons dès que vous serez en ligne.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (au $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dépenses',
      one: '1 dépense',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Créez votre premier voyage';

  @override
  String get emptyBody =>
      'Nous convertissons vos dépenses à l\'étranger dans votre devise au taux du jour du paiement\net les conservons dans votre propre feuille Google Sheets.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Connectez-vous avec votre compte Google : une feuille « $fileName » est créée dans votre Google Drive et mise à jour à chaque dépense enregistrée. L\'app n\'a accès qu\'à la feuille qu\'elle a créée, et vos données ne sont jamais envoyées à nos serveurs.';
  }

  @override
  String get connectGoogle => 'Connecter un compte Google';

  @override
  String get syncNow => 'Enregistrer maintenant';

  @override
  String get openSheet => 'Ouvrir la feuille';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get rateInfoTitle => 'À propos des taux de change';

  @override
  String get rateInfoBody =>
      'Les montants dans votre devise utilisent le taux de référence du jour du paiement (Banque centrale européenne, ou données de taux publiques pour les autres devises). Les week-ends et jours fériés, le taux du jour ouvré précédent s\'applique. Votre relevé de carte peut légèrement différer en raison du taux et des frais de l\'émetteur de la carte.';

  @override
  String googleSignInError(String details) {
    return 'Erreur de connexion Google : $details';
  }

  @override
  String get syncSaved => 'Enregistré dans la feuille';

  @override
  String syncFailed(String details) {
    return 'Échec de l\'enregistrement dans la feuille : $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Vous n\'êtes pas connecté à Google.';

  @override
  String get syncErrorNoPermission =>
      'L\'autorisation Google Drive est nécessaire. Veuillez vous reconnecter.';

  @override
  String get syncErrorExpired =>
      'Votre connexion Google a expiré. Veuillez vous reconnecter.';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Automatique (selon la nationalité)';

  @override
  String get catFood => 'Repas';

  @override
  String get catSnack => 'Snacks/Café';

  @override
  String get catSouvenir => 'Souvenirs';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTransport => 'Transport';

  @override
  String get catLodging => 'Hébergement';

  @override
  String get catSightseeing => 'Visites';

  @override
  String get catOther => 'Autre';

  @override
  String get sourceManual => 'Manuel';

  @override
  String get sourceReceipt => 'Reçu';

  @override
  String get sourceCard => 'Alerte carte';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Dépenses';

  @override
  String get tabTrips => 'Voyages';

  @override
  String get tabSummary => 'Résumé';

  @override
  String get colTrip => 'Voyage';

  @override
  String get colDate => 'Date';

  @override
  String get colTime => 'Heure';

  @override
  String get colCategory => 'Catégorie';

  @override
  String get colMerchant => 'Commerçant';

  @override
  String get colCurrency => 'Devise';

  @override
  String get colLocalAmount => 'Montant local';

  @override
  String get colRateDate => 'Date du taux';

  @override
  String get colPayment => 'Paiement';

  @override
  String get colSource => 'Source';

  @override
  String get colMemo => 'Note';

  @override
  String get colRateSource => 'Source du taux';

  @override
  String get colCountry => 'Pays';

  @override
  String get colStartDate => 'Début';

  @override
  String get colEndDate => 'Fin';

  @override
  String get colCount => 'Nombre';

  @override
  String get colShare => 'Part (%)';

  @override
  String get scanReceipt => 'Scanner un reçu';

  @override
  String get pickReceipt => 'Reçu depuis les photos';

  @override
  String get enterManually => 'Saisir manuellement';

  @override
  String get readingReceipt => 'Lecture du reçu…';

  @override
  String get receiptReadNotice =>
      'Rempli à partir de votre reçu. Vérifiez et corrigez avant d\'enregistrer. La photo a été supprimée après analyse.';

  @override
  String get receiptNothingFound =>
      'Aucun montant trouvé sur le reçu. Veuillez le saisir manuellement. La photo a été supprimée.';

  @override
  String receiptScanFailed(String details) {
    return 'Impossible de lire le reçu : $details';
  }

  @override
  String get photoDeletedNote =>
      'Les photos sont analysées sur votre appareil puis supprimées aussitôt. Elles ne sont jamais stockées ni envoyées.';

  @override
  String get cardAlertsSection => 'Enregistrer auto les paiements par carte';

  @override
  String get cardAlertsBody =>
      'Lorsque vous payez par carte à l\'étranger, la notification d\'autorisation de votre app bancaire (ou messagerie) est lue et enregistrée dans le voyage correspondant à cette date. Seules les autorisations en devise étrangère sont traitées, sur votre appareil. Les autres notifications ne sont jamais stockées ni envoyées.';

  @override
  String get cardAlertsOn => 'Activé';

  @override
  String get cardAlertsOff => 'Désactivé (accès aux notifications requis)';

  @override
  String get cardAlertsAllow => 'Autoriser l\'accès aux notifications';

  @override
  String get cardAlertsSettings =>
      'Ouvrir les réglages d\'accès aux notifications';

  @override
  String get cardAlertsConsentTitle => 'À propos de l\'accès aux notifications';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Sur l\'écran suivant, autorisez l\'accès aux notifications pour « $appName ». L\'app ne retiendra parmi vos notifications que les autorisations de paiement par carte à l\'étranger et les enregistrera comme dépenses. Le contenu des notifications ne quitte jamais votre appareil, et vous pouvez désactiver cette option à tout moment dans le même réglage.';
  }

  @override
  String get agreeAndContinue => 'Accepter et continuer';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paiements par carte attendent',
      one: '1 paiement par carte attend',
    );
    return '$_temp0 un voyage couvrant la date du paiement. Créez ce voyage et ils y seront ajoutés automatiquement.';
  }

  @override
  String get pasteCardAlert => 'Coller le texte de l\'alerte carte';

  @override
  String get pasteCardAlertHint =>
      'Collez la notification d\'autorisation reçue de votre app bancaire ou par SMS.';

  @override
  String get pasteCardAlertFailed =>
      'Impossible de lire ceci comme une autorisation de paiement à l\'étranger. Veuillez saisir la dépense manuellement.';

  @override
  String get cardReadNotice =>
      'Rempli à partir de votre alerte carte. Vérifiez et corrigez avant d\'enregistrer.';

  @override
  String get read => 'Lire';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String colHomeRate(String currency) {
    return 'Taux ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Montant ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Total ($currency)';
  }

  @override
  String get noConvertedYet => 'Aucune dépense convertie pour l\'instant';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Nationalité';

  @override
  String get chooseNationality => 'Sélectionnez votre nationalité';

  @override
  String get nationalityBody =>
      'Toutes les dépenses seront converties dans la devise de votre pays, et la langue de l\'app sera adaptée. Vous pourrez modifier cela plus tard dans les Paramètres.';

  @override
  String get searchCountry => 'Rechercher un pays';

  @override
  String get homeCurrency => 'Devise principale';

  @override
  String get welcomeTitle => 'Bienvenue dans Travel Expense';

  @override
  String get welcomeBody =>
      'Connectez votre compte Google pour enregistrer automatiquement vos dépenses dans une feuille de votre propre Google Drive.';

  @override
  String get skipForNow => 'Plus tard';

  @override
  String get next => 'Suivant';

  @override
  String get exportTripSheet => 'Enregistrer dans Google Sheets';

  @override
  String get exportTripSheetSaving => 'Enregistrement dans Google Sheets…';

  @override
  String exportTripSheetDone(String title) {
    return 'Enregistré dans la feuille « $title »';
  }
}
