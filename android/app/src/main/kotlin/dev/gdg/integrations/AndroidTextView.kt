package dev.gdg.integrations

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class AndroidTextView(context: Context, id: Int, creationParams: Map<String?, Any?>?, messenger: BinaryMessenger) : PlatformView,
    MethodChannel.MethodCallHandler {
    private val textView: TextView = TextView(context)
    private val methodChannel: MethodChannel

    private val methodChannelId= "integrations.gdg.dev/channel"

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView.textSize = 20f
        textView.setTextColor(Color.WHITE)
        textView.setBackgroundColor(Color.BLUE)
        textView.text = "Rendered on a native Android"
        methodChannel = MethodChannel(messenger, methodChannelId)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "ping" -> setText(methodCall, result)
            else -> result.notImplemented()
        }
    }

    private fun setText(methodCall: MethodCall, result: MethodChannel.Result) {
        textView.text = methodCall.arguments as String
        result.success(null)
    }
}