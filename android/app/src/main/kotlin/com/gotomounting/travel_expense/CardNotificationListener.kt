package com.gotomounting.travel_expense

import android.app.Notification
import android.os.Handler
import android.os.Looper
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import org.json.JSONObject

/**
 * 카드 앱·카카오톡 알림톡 등으로 온 결제 승인 알림을 받는다.
 *
 * 모든 알림을 저장하지 않는다. "승인" 등의 표시와 외화 통화 코드가 함께
 * 있는 알림만 [CardNotificationStore] 에 넣고, 나머지는 읽고 바로 버린다.
 * 실제 금액·가맹점 해석은 앱(Dart)에서 한다.
 */
class CardNotificationListener : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        if (sbn.packageName == packageName) return
        val extras = sbn.notification?.extras ?: return
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val body = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
            ?: extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
            ?: ""
        val text = "$title\n$body"
        if (!looksLikeForeignPayment(text)) return

        val item = JSONObject()
            .put("id", "${sbn.packageName}|${sbn.postTime}|${body.hashCode()}")
            .put("package", sbn.packageName)
            .put("title", title)
            .put("text", body)
            .put("postedAt", sbn.postTime)
        CardNotificationStore.add(applicationContext, item)
        notifyApp()
    }

    companion object {
        // 결제 알림 표시 (앱이 지원하는 14개 언어 나라의 카드사·은행 표기).
        // 실제 해석은 Dart 의 CardNotificationParser 가 하고, 여기서는 결제 알림이
        // 아닌 것을 저장하지 않으려고 넓게 거른다.
        private val approved = Regex(
            "승인|approved|approval|purchase|spent|charged|debited|transaction|payment of|paid|txn|" +
                "承認|ご利用|利用|決済|批准|已消费|消费|消費|支付|交易|刷卡|" +
                "giao dịch|\\bGD\\b|thanh toán|chi tiêu|" +
                "покупка|оплата|списание|" +
                "zahlung|bezahlt|umsatz|belastung|" +
                "гүйлгээ|төлбөр|зарцуулалт|худалдан авалт|" +
                "paiement|achat|débit|" +
                "ငွေပေးချေ|ဝယ်ယူ|" +
                "nagbayad|bayad|binili|" +
                "transaksi|pembelian|pembayaran|bayaran|belian|" +
                "लेनदेन|खर्च|भुगतान|डेबिट",
            RegexOption.IGNORE_CASE,
        )

        // 통화 코드나 통화 기호가 붙은 금액. 내 나라 통화인지는 Dart 에서 가린다
        // (외국인 사용자는 원화 결제가 해외 결제다).
        private val currencyAmount = Regex(
            "\\b[A-Z]{3}[  ]?\\d|\\d[  ]?[A-Z]{3}\\b|" +
                "[₩￦€£₫₽₮₹₱฿₺¥￥$]|\\d[  ]?(원|円|元|đ|Ks|zł|Kč|төг|руб)|\\b(Rp|RM|Rs)\\.?[  ]?\\d",
        )

        fun looksLikeForeignPayment(text: String): Boolean =
            approved.containsMatchIn(text) && currencyAmount.containsMatchIn(text)

        /** 앱이 켜져 있으면 새 알림이 왔다고 알려 준다 (MainActivity 가 등록). */
        @Volatile
        var onNewItem: (() -> Unit)? = null

        private fun notifyApp() {
            val callback = onNewItem ?: return
            Handler(Looper.getMainLooper()).post { callback() }
        }
    }
}
