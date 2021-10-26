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
import kotlinx.coroutines.*

class MainActivity: FlutterActivity() {

    private val androidViewId= "integrations.gdg.dev/android"
    private val eventsChannel = "integrations.gdg.dev/events"
    private val intentName = "EVENTS"
    private val intentMessageId = "PING"

    private var receiver: BroadcastReceiver? = null
    lateinit var job: Job

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(androidViewId, AndroidTextViewFactory(flutterEngine.dartExecutor.binaryMessenger))

        EventChannel(flutterEngine.dartExecutor, eventsChannel).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventChannel.EventSink) {
                        val intent = Intent(intentName)
                        receiver = createReceiver(events)
                        applicationContext?.registerReceiver(receiver, IntentFilter(intentName))
                        job = CoroutineScope(Dispatchers.Default).launch {
                            for (i in 100..300 step 50) {
                                intent.putExtra(intentMessageId, i)
                                applicationContext?.sendBroadcast(intent)
                                delay(1000)
                            }
                        }
                    }

                    override fun onCancel(args: Any?) {
                        job.cancel()
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
