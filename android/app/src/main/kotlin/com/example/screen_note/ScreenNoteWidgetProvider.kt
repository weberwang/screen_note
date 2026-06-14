package com.example.screen_note

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

/**
 * Android 桌面小组件宿主。
 *
 * 这里只读取 Flutter 已写入的稳定共享快照并完成渲染与回流，
 * 不直接查库、不重排任务，也不在原生层重做隐私判断。
 */
class ScreenNoteWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        appWidgetIds.forEach { appWidgetId ->
            appWidgetManager.updateAppWidget(appWidgetId, buildRemoteViews(context))
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val manager = AppWidgetManager.getInstance(context)
            // 这里优先消费系统透传的 id，避免 super 与手动分支各刷一遍导致重复更新。
            val widgetIds = intent.getIntArrayExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS)
                ?: manager.getAppWidgetIds(
                    ComponentName(context, ScreenNoteWidgetProvider::class.java),
                )
            if (widgetIds.isNotEmpty()) {
                onUpdate(context, manager, widgetIds)
            }
            return
        }
        super.onReceive(context, intent)
    }

    /**
     * 把共享快照绑定到 RemoteViews；Android 侧只消费前 2 条，不额外变更顺序。
     */
    private fun buildRemoteViews(context: Context): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.screen_note_widget)
        val snapshot = loadSnapshot(context)
        val items = snapshot?.optJSONArray(KEY_ITEMS) ?: JSONArray()
        val headerTitle = snapshot?.optString(KEY_HEADER_TITLE).orEmpty()
        val emptyTitle = snapshot?.optString(KEY_EMPTY_TITLE).orEmpty()
        val emptyBody = snapshot?.optString(KEY_EMPTY_BODY).orEmpty()

        views.setTextViewText(
            R.id.widget_header,
            headerTitle.ifBlank { context.getString(R.string.screen_note_widget_name) },
        )

        val firstItem = items.optJSONObject(0)
        val secondItem = items.optJSONObject(1)

        if (firstItem == null && secondItem == null) {
            bindEmptyState(
                context = context,
                views = views,
                title = emptyTitle,
                body = emptyBody,
            )
        } else {
            bindItem(
                context = context,
                views = views,
                containerId = R.id.item_one_container,
                titleId = R.id.item_one_title,
                metaId = R.id.item_one_meta,
                item = firstItem,
            )
            bindItem(
                context = context,
                views = views,
                containerId = R.id.item_two_container,
                titleId = R.id.item_two_title,
                metaId = R.id.item_two_meta,
                item = secondItem,
            )
        }

        views.setOnClickPendingIntent(
            R.id.widget_root,
            createActivityPendingIntent(
                context = context,
                requestCode = REQUEST_CODE_ROOT,
                deepLink = HOME_DEEP_LINK,
            ),
        )
        return views
    }

    /**
     * 共享快照优先读 current，异常或缺失时退回 last_valid，避免刷新失败时直接白屏。
     */
    private fun loadSnapshot(context: Context): JSONObject? {
        val preferences = context.getSharedPreferences(
            HOME_WIDGET_PREFERENCES,
            Context.MODE_PRIVATE,
        )
        return parseSnapshot(preferences.getString(KEY_CURRENT_SNAPSHOT, null))
            ?: parseSnapshot(preferences.getString(KEY_LAST_VALID_SNAPSHOT, null))
    }

    /**
     * 只接受当前约定的 version 2 共享合同，旧版本或脏数据统一回退到更安全的来源。
     */
    private fun parseSnapshot(payload: String?): JSONObject? {
        if (payload.isNullOrBlank()) {
            return null
        }
        return try {
            JSONObject(payload).takeIf { snapshot ->
                snapshot.optInt(KEY_VERSION, INVALID_VERSION) == SNAPSHOT_VERSION
            }
        } catch (_: JSONException) {
            null
        }
    }

    /**
     * 空态复用共享快照给出的文案，并复用第一行容器展示，减少额外布局分叉。
     */
    private fun bindEmptyState(
        context: Context,
        views: RemoteViews,
        title: String,
        body: String,
    ) {
        views.setViewVisibility(R.id.item_one_container, View.VISIBLE)
        views.setTextViewText(
            R.id.item_one_title,
            title.ifBlank { context.getString(R.string.screen_note_widget_empty_title) },
        )
        val message = body.ifBlank {
            context.getString(R.string.screen_note_widget_empty_body)
        }
        views.setTextViewText(R.id.item_one_meta, message)
        views.setViewVisibility(R.id.item_one_meta, View.VISIBLE)
        views.setOnClickPendingIntent(
            R.id.item_one_container,
            createActivityPendingIntent(
                context = context,
                requestCode = REQUEST_CODE_ITEM_ONE,
                deepLink = HOME_DEEP_LINK,
            ),
        )
        views.setViewVisibility(R.id.item_two_container, View.GONE)
    }

    /**
     * 条目点击只负责把冻结好的展示字段绑定到视图，并交给共享快照约定生成回流链接。
     */
    private fun bindItem(
        context: Context,
        views: RemoteViews,
        containerId: Int,
        titleId: Int,
        metaId: Int,
        item: JSONObject?,
    ) {
        if (item == null) {
            views.setViewVisibility(containerId, View.GONE)
            return
        }

        views.setViewVisibility(containerId, View.VISIBLE)
        views.setTextViewText(titleId, item.optString(KEY_ITEM_TITLE))

        val meta = listOf(
            item.optString(KEY_ITEM_STATUS_LABEL),
            item.optString(KEY_ITEM_DUE_LABEL),
        ).filter { it.isNotBlank() }.joinToString(SEPARATOR_DOT)

        if (meta.isBlank()) {
            views.setViewVisibility(metaId, View.GONE)
        } else {
            views.setViewVisibility(metaId, View.VISIBLE)
            views.setTextViewText(metaId, meta)
        }

        val deepLink = buildItemDeepLink(item)
        views.setOnClickPendingIntent(
            containerId,
            createActivityPendingIntent(
                context = context,
                requestCode = containerId,
                deepLink = deepLink,
            ),
        )
    }

    /**
     * PendingIntent 统一走 MainActivity 的深链入口，避免原生侧分叉业务导航。
     */
    private fun createActivityPendingIntent(
        context: Context,
        requestCode: Int,
        deepLink: String,
    ): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
                // home_widget 0.9.1 只会在这个固定 action 下把点击事件回传给 Flutter。
                action = HOME_WIDGET_LAUNCH_ACTION
                data = Uri.parse(deepLink)
                addFlags(
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_NEW_TASK,
                )
            }
        return PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    /**
     * 条目回流以共享快照里的 launchTarget 为准；只有明确声明 task 才尝试带 taskId 进入事项。
     */
    private fun buildItemDeepLink(item: JSONObject): String {
        val launchTarget = item.optString(KEY_ITEM_LAUNCH_TARGET).trim()
        if (launchTarget != LAUNCH_TARGET_TASK) {
            return HOME_DEEP_LINK
        }

        val taskId = item.optString(KEY_ITEM_TASK_ID).trim()
        return if (taskId.isNotEmpty()) {
            "$TASK_DEEP_LINK_PREFIX$taskId"
        } else {
            HOME_DEEP_LINK
        }
    }

    companion object {
        private const val HOME_WIDGET_PREFERENCES = "HomeWidgetPreferences"
        private const val KEY_CURRENT_SNAPSHOT = "screen_note.widget_snapshot.current"
        private const val KEY_LAST_VALID_SNAPSHOT = "screen_note.widget_snapshot.last_valid"
        private const val KEY_VERSION = "version"
        private const val KEY_HEADER_TITLE = "headerTitle"
        private const val KEY_EMPTY_TITLE = "emptyTitle"
        private const val KEY_EMPTY_BODY = "emptyBody"
        private const val KEY_ITEMS = "items"
        private const val KEY_ITEM_TITLE = "title"
        private const val KEY_ITEM_STATUS_LABEL = "statusLabel"
        private const val KEY_ITEM_DUE_LABEL = "dueLabel"
        private const val KEY_ITEM_TASK_ID = "taskId"
        private const val KEY_ITEM_LAUNCH_TARGET = "launchTarget"
        private const val SNAPSHOT_VERSION = 2
        private const val INVALID_VERSION = -1
        private const val LAUNCH_TARGET_TASK = "task"
        private const val HOME_DEEP_LINK = "screennote://launch?source=widget&target=home"
        private const val TASK_DEEP_LINK_PREFIX =
            "screennote://launch?source=widget&target=task&taskId="
        private const val HOME_WIDGET_LAUNCH_ACTION =
            "es.antonborri.home_widget.action.LAUNCH"
        private const val SEPARATOR_DOT = " · "
        private const val REQUEST_CODE_ROOT = 1000
        private const val REQUEST_CODE_ITEM_ONE = 1001
    }
}
