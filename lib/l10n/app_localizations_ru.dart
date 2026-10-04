// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Настройки';

  @override
  String get newTrip => 'Новая поездка';

  @override
  String get editTrip => 'Изменить поездку';

  @override
  String get deleteTrip => 'Удалить поездку';

  @override
  String get tripTitle => 'Название поездки';

  @override
  String get tripTitleHint => 'напр.: Семьёй в Токио 2026';

  @override
  String get tripTitleRequired => 'Введите название поездки';

  @override
  String get countryOptional => 'Страна/город (необязательно)';

  @override
  String get countryHint => 'напр.: Токио, Япония';

  @override
  String get localCurrency => 'Местная валюта';

  @override
  String get currency => 'Валюта';

  @override
  String get tripPeriod => 'Даты поездки';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteTripConfirmTitle => 'Удалить эту поездку?';

  @override
  String get deleteTripConfirmBody =>
      'Все расходы этой поездки будут удалены и исчезнут из таблицы при следующей синхронизации.';

  @override
  String get totalSpent => 'Всего потрачено';

  @override
  String pendingRates(int count) {
    return 'Ожидают курса: $count (потяните вниз для обновления, когда будете онлайн)';
  }

  @override
  String get firstExpenseHint => 'Нажмите +, чтобы записать первый расход';

  @override
  String get addExpense => 'Добавить расход';

  @override
  String get editExpense => 'Изменить расход';

  @override
  String get ratePending => 'Курс ожидается';

  @override
  String get amount => 'Сумма';

  @override
  String get amountRequired => 'Введите сумму';

  @override
  String get category => 'Категория';

  @override
  String get merchantOptional => 'Продавец (необязательно)';

  @override
  String get merchantHint => 'напр.: Ichiran Ramen';

  @override
  String get paymentOptional => 'Способ оплаты (необязательно)';

  @override
  String get paymentHint => 'напр.: карта Visa, наличные';

  @override
  String get memoOptional => 'Заметка (необязательно)';

  @override
  String get checkingRate => 'Проверяем курс…';

  @override
  String get rateUnavailable =>
      'Сейчас не удаётся получить курс. Сохраните расход — мы пересчитаем его, когда появится интернет.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (на $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count расхода',
      many: '$count расходов',
      few: '$count расхода',
      one: '$count расход',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Создайте первую поездку';

  @override
  String get emptyBody =>
      'Мы пересчитываем ваши расходы за границей в домашнюю валюту по курсу на дату оплаты\nи сохраняем их в вашей собственной таблице Google Sheets.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Войдите через аккаунт Google — в вашем Google Drive будет создана таблица «$fileName», которая обновляется при каждой записи расхода. Приложение имеет доступ только к созданной им таблице, а ваши данные никогда не отправляются на наши серверы.';
  }

  @override
  String get connectGoogle => 'Подключить аккаунт Google';

  @override
  String get syncNow => 'Сохранить сейчас';

  @override
  String get openSheet => 'Открыть таблицу';

  @override
  String get disconnect => 'Отключить';

  @override
  String get rateInfoTitle => 'О курсах валют';

  @override
  String get rateInfoBody =>
      'Суммы в домашней валюте рассчитываются по справочному курсу на дату оплаты (Европейский центральный банк или открытые данные о курсах для других валют). В выходные и праздники используется курс предыдущего рабочего дня. Фактическое списание по карте может немного отличаться из-за курса и комиссий банка-эмитента.';

  @override
  String googleSignInError(String details) {
    return 'Ошибка входа в Google: $details';
  }

  @override
  String get syncSaved => 'Сохранено в таблицу';

  @override
  String syncFailed(String details) {
    return 'Не удалось сохранить в таблицу: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Вы не вошли в Google.';

  @override
  String get syncErrorNoPermission =>
      'Нужен доступ к Google Drive. Подключитесь заново.';

  @override
  String get syncErrorExpired =>
      'Срок входа в Google истёк. Подключитесь заново.';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Автоматически (по гражданству)';

  @override
  String get catFood => 'Еда';

  @override
  String get catSnack => 'Перекусы/кафе';

  @override
  String get catSouvenir => 'Сувениры';

  @override
  String get catShopping => 'Покупки';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catLodging => 'Жильё';

  @override
  String get catSightseeing => 'Экскурсии';

  @override
  String get catOther => 'Другое';

  @override
  String get sourceManual => 'Вручную';

  @override
  String get sourceReceipt => 'Чек';

  @override
  String get sourceCard => 'Уведомление карты';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Расходы';

  @override
  String get tabTrips => 'Поездки';

  @override
  String get tabSummary => 'Сводка';

  @override
  String get colTrip => 'Поездка';

  @override
  String get colDate => 'Дата';

  @override
  String get colTime => 'Время';

  @override
  String get colCategory => 'Категория';

  @override
  String get colMerchant => 'Продавец';

  @override
  String get colCurrency => 'Валюта';

  @override
  String get colLocalAmount => 'Сумма в местной валюте';

  @override
  String get colRateDate => 'Дата курса';

  @override
  String get colPayment => 'Оплата';

  @override
  String get colSource => 'Источник';

  @override
  String get colMemo => 'Заметка';

  @override
  String get colRateSource => 'Источник курса';

  @override
  String get colCountry => 'Страна';

  @override
  String get colStartDate => 'Начало';

  @override
  String get colEndDate => 'Конец';

  @override
  String get colCount => 'Кол-во';

  @override
  String get colShare => 'Доля (%)';

  @override
  String get scanReceipt => 'Сканировать чек';

  @override
  String get pickReceipt => 'Чек из галереи';

  @override
  String get enterManually => 'Ввести вручную';

  @override
  String get readingReceipt => 'Читаем чек…';

  @override
  String get receiptReadNotice =>
      'Заполнено по чеку. Проверьте и исправьте перед сохранением. Фото удалено после анализа.';

  @override
  String get receiptNothingFound =>
      'Не удалось найти сумму на чеке. Введите её вручную. Фото удалено.';

  @override
  String receiptScanFailed(String details) {
    return 'Не удалось прочитать чек: $details';
  }

  @override
  String get photoDeletedNote =>
      'Фото анализируются на вашем устройстве и сразу удаляются. Они нигде не хранятся и никуда не отправляются.';

  @override
  String get cardAlertsSection => 'Автозапись оплат картой';

  @override
  String get cardAlertsBody =>
      'Когда вы платите картой за границей, уведомление об оплате из банковского приложения (или мессенджера) считывается и записывается в поездку на эту дату. Обрабатываются только уведомления об оплате в иностранной валюте — прямо на вашем устройстве. Другие уведомления никогда не сохраняются и никуда не отправляются.';

  @override
  String get cardAlertsOn => 'Вкл.';

  @override
  String get cardAlertsOff => 'Выкл. (нужен доступ к уведомлениям)';

  @override
  String get cardAlertsAllow => 'Разрешить доступ к уведомлениям';

  @override
  String get cardAlertsSettings => 'Открыть настройки доступа к уведомлениям';

  @override
  String get cardAlertsConsentTitle => 'О доступе к уведомлениям';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'На следующем экране разрешите доступ к уведомлениям для «$appName». Приложение будет выбирать из уведомлений только оплаты картой за границей и записывать их как расходы. Содержимое уведомлений не покидает ваше устройство, и вы можете отключить это в любой момент в тех же настройках.';
  }

  @override
  String get agreeAndContinue => 'Принять и продолжить';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count оплаты картой ожидают',
      many: '$count оплат картой ожидают',
      few: '$count оплаты картой ожидают',
      one: '$count оплата картой ожидает',
    );
    return '$_temp0 поездку, которая охватывает дату оплаты. Создайте такую поездку, и они добавятся автоматически.';
  }

  @override
  String get pasteCardAlert => 'Вставить текст уведомления';

  @override
  String get pasteCardAlertHint =>
      'Вставьте уведомление об оплате из банковского приложения или SMS.';

  @override
  String get pasteCardAlertFailed =>
      'Не удалось распознать это как оплату за границей. Введите расход вручную.';

  @override
  String get cardReadNotice =>
      'Заполнено по уведомлению карты. Проверьте и исправьте перед сохранением.';

  @override
  String get read => 'Распознать';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String colHomeRate(String currency) {
    return 'Курс ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Сумма ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Итого ($currency)';
  }

  @override
  String get noConvertedYet => 'Пока нет пересчитанных расходов';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Гражданство';

  @override
  String get chooseNationality => 'Выберите гражданство';

  @override
  String get nationalityBody =>
      'Все расходы будут пересчитываться в валюту вашей страны, а язык приложения подстроится под неё. Это можно изменить позже в настройках.';

  @override
  String get searchCountry => 'Поиск страны';

  @override
  String get homeCurrency => 'Домашняя валюта';

  @override
  String get welcomeTitle => 'Добро пожаловать в Travel Expense';

  @override
  String get welcomeBody =>
      'Подключите аккаунт Google, чтобы расходы автоматически сохранялись в таблицу в вашем Google Drive.';

  @override
  String get skipForNow => 'Не сейчас';

  @override
  String get next => 'Далее';

  @override
  String get exportTripSheet => 'Сохранить в Google Таблицы';

  @override
  String get exportTripSheetSaving => 'Сохранение в Google Таблицы…';

  @override
  String exportTripSheetDone(String title) {
    return 'Сохранено в таблицу «$title»';
  }

  @override
  String get receiptTotalNotFound =>
      'Не удалось определить итоговую сумму в чеке. Введите сумму и валюту вручную. Фото удалено после анализа.';

  @override
  String get receiptCurrencyNotFound =>
      'Не удалось определить валюту в чеке. Проверьте сумму и выберите валюту вручную. Фото удалено после анализа.';

  @override
  String get currencyRequired => 'Выберите валюту';

  @override
  String batchTitle(int count) {
    return 'Найдено платежей: $count';
  }

  @override
  String get batchHint =>
      'Выберите, что сохранить. Нажмите на сумму, чтобы изменить.';

  @override
  String batchSave(int count) {
    return 'Сохранить выбранные ($count)';
  }

  @override
  String batchSaved(int count) {
    return 'Сохранено: $count';
  }

  @override
  String get batchOutsideTrip => 'Вне дат поездки';

  @override
  String get batchDuplicate => 'Уже сохранено';

  @override
  String get batchNeedsInput => 'Проверьте сумму/валюту · нажмите на сумму';

  @override
  String get scanIncomplete =>
      'Некоторые платежи не удалось прочитать. Введите каждый платёж вручную.';
}
