package dev.gdg.integrations

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class AndroidTextViewFactory(messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private val binaryMessenger: BinaryMessenger = messenger

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return AndroidTextView(context, viewId, creationParams, binaryMessenger)
    }
}