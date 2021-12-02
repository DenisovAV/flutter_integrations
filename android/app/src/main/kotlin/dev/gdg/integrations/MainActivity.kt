package dev.gdg.integrations

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlin.random.Random

class MainActivity: FlutterActivity() {

    private val androidViewId= "INTEGRATION_ANDROID"
    private val eventsChannel = "CALL_EVENTS"
    private val methodChannel = "CALL_METHOD"
    private val intentName = "EVENTS"
    private val intentMessageId = "CALL"

    private var receiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(androidViewId, AndroidButtonViewFactory(flutterEngine.dartExecutor.binaryMessenger))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler {
                call, result ->
            if (call.method == intentMessageId) {
                result.success(Random.nextInt(0, 500))
            } else {
                result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor, eventsChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(args: Any?, events: EventChannel.EventSink) {
                    val intent = Intent(intentName)
                    receiver = createReceiver(events)
                    applicationContext?.registerReceiver(receiver, IntentFilter(intentName))
                }

                override fun onCancel(args: Any?) {
                    receiver = null
                }
            }
        )
    }

    fun createReceiver(events: EventChannel.EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) { // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW
                events.success(intent.getIntExtra(intentMessageId, 0))
            }
        }
    }
}
