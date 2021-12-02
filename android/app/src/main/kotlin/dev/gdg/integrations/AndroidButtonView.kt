package dev.gdg.integrations

import android.R
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlin.random.Random


internal class AndroidButtonView(context: Context, id: Int, creationParams: Map<String?, Any?>?, messenger: BinaryMessenger) : PlatformView {
    private val button: Button = Button(context)

    private val intentName = "EVENTS"
    private val intentMessageId = "CALL"


    override fun getView(): View {
        return button
    }

    override fun dispose() {}

    init {
        button.textSize = 13f
        button.text = "Android Native Button"
        button.setOnClickListener {
            val intent = Intent(intentName)
            intent.putExtra(intentMessageId, Random.nextInt(0, 500))
            context.sendBroadcast(intent)
        }
    }

}