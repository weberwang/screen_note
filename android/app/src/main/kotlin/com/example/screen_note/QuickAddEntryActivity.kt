package com.example.screen_note

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

/**
 * Android 原生快速入口中转页。
 *
 * 这里只负责把系统入口意图归一化成 Flutter 已有的 quick add 草稿协议，
 * 再交回主应用统一消费，避免在原生层直接创建事项或分叉业务流程。
 */
class QuickAddEntryActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        persistPendingDraft(intent)
        launchMainActivity()
        finish()
    }

    /**
     * 把原生入口携带的数据转换成统一草稿 JSON。
     *
     * Android 侧先统一落成 deepLink 来源，后续真有额外系统入口时再扩展来源映射，
     * 避免这一版为了凑齐 iOS 语义枚举而引入多套 Android 原生入口。
     */
    private fun persistPendingDraft(entryIntent: Intent?) {
        val now = iso8601Now()
        val draftText = entryIntent?.getStringExtra(EXTRA_DRAFT_TEXT)
            ?: entryIntent?.data?.getQueryParameter(QUERY_DRAFT_TEXT)
            ?: ""
        val payload = JSONObject(
            mapOf(
                "draftText" to draftText,
                "source" to "deepLink",
                "isPinned" to false,
                "isPrivate" to false,
                "hasUnsavedChanges" to true,
                "createdAt" to now,
                "updatedAt" to now,
            ),
        )

        getSharedPreferences(HOME_WIDGET_PREFERENCES, Context.MODE_PRIVATE)
            .edit()
            .putString(PENDING_DRAFT_STORAGE_KEY, payload.toString())
            // 这里必须同步落盘，避免紧接着拉起 Flutter 时先读到旧值或空值。
            .commit()
    }

    /**
     * 拉起 Flutter 主入口，让应用层统一恢复草稿并跳转 `/quick-add`。
     */
    private fun launchMainActivity() {
        startActivity(
            Intent(this, MainActivity::class.java).apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_NEW_TASK,
                )
            },
        )
    }

    companion object {
        private const val HOME_WIDGET_PREFERENCES = "HomeWidgetPreferences"
        private const val PENDING_DRAFT_STORAGE_KEY = "screen_note.quick_add.intent_payload"
        private const val EXTRA_DRAFT_TEXT = "draft_text"
        private const val QUERY_DRAFT_TEXT = "draftText"

        /**
         * 统一输出 UTC ISO8601 时间，保持与 Flutter/iOS 草稿时间字段格式一致。
         */
        private fun iso8601Now(): String {
            return SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US).apply {
                timeZone = TimeZone.getTimeZone("UTC")
            }.format(Date())
        }
    }
}
