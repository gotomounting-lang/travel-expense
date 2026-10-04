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
        private val approved = Regex("승인|approved|approval|承認|批准|消費|已消费", RegexOption.IGNORE_CASE)
        private val foreignAmount = Regex("\\b(?!KRW)[A-Z]{3}\\s?\\d|\\d\\s?(?!KRW)[A-Z]{3}\\b")

        fun looksLikeForeignPayment(text: String): Boolean =
            approved.containsMatchIn(text) && foreignAmount.containsMatchIn(text)

        /** 앱이 켜져 있으면 새 알림이 왔다고 알려 준다 (MainActivity 가 등록). */
        @Volatile
        var onNewItem: (() -> Unit)? = null

        private fun notifyApp() {
            val callback = onNewItem ?: return
            Handler(Looper.getMainLooper()).post { callback() }
        }
    }
}
