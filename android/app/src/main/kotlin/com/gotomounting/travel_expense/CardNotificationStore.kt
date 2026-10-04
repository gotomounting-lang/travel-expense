package com.gotomounting.travel_expense

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

/**
 * 카드 결제로 보이는 알림을 앱이 꺼내 갈 때까지 기기 안에 잠깐 보관한다.
 * 앱이 꺼져 있을 때 온 알림도 놓치지 않기 위해서다. 앱이 읽어서 지출로
 * 기록하면 바로 지우고, 30일이 지난 것도 지운다. 기기 밖으로 보내지 않는다.
 */
object CardNotificationStore {
    private const val PREFS = "card_notifications"
    private const val KEY = "pending"
    private const val MAX_ITEMS = 200
    private const val MAX_AGE_MS = 30L * 24 * 60 * 60 * 1000

    @Synchronized
    fun add(context: Context, item: JSONObject) {
        val items = load(context)
        val id = item.getString("id")
        for (i in 0 until items.length()) {
            if (items.getJSONObject(i).getString("id") == id) return
        }
        items.put(item)
        save(context, items)
    }

    @Synchronized
    fun all(context: Context): List<Map<String, Any>> {
        val items = load(context)
        val out = ArrayList<Map<String, Any>>()
        for (i in 0 until items.length()) {
            val o = items.getJSONObject(i)
            out.add(
                mapOf(
                    "id" to o.getString("id"),
                    "package" to o.optString("package"),
                    "title" to o.optString("title"),
                    "text" to o.optString("text"),
                    "postedAt" to o.getLong("postedAt"),
                )
            )
        }
        return out
    }

    @Synchronized
    fun remove(context: Context, ids: Collection<String>) {
        val items = load(context)
        val kept = JSONArray()
        for (i in 0 until items.length()) {
            val o = items.getJSONObject(i)
            if (!ids.contains(o.getString("id"))) kept.put(o)
        }
        save(context, kept)
    }

    private fun load(context: Context): JSONArray {
        val raw = prefs(context).getString(KEY, null) ?: return JSONArray()
        return try {
            JSONArray(raw)
        } catch (e: Exception) {
            JSONArray()
        }
    }

    private fun save(context: Context, items: JSONArray) {
        val now = System.currentTimeMillis()
        val fresh = ArrayList<JSONObject>()
        for (i in 0 until items.length()) {
            val o = items.getJSONObject(i)
            if (now - o.getLong("postedAt") <= MAX_AGE_MS) fresh.add(o)
        }
        val trimmed = JSONArray()
        fresh.takeLast(MAX_ITEMS).forEach { trimmed.put(it) }
        prefs(context).edit().putString(KEY, trimmed.toString()).apply()
    }

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
}
