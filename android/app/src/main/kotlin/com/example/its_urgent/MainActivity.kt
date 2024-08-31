package com.hsiharki.itsurgent

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.NotificationManager
import io.flutter.plugin.common.StandardMethodCodec


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.hsiharki.itsurgent/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //main
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getBatteryLevel") {
                
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "getFocusStatus") {
                val focusStatus = getFocusStatus()
                result.success(focusStatus)
            }
            else if (call.method == "canBypassDnd"){
                val interruptionLevel = canBypassDnd()
                result.success(interruptionLevel)
            }
        }




    }

    



    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }

    private fun getFocusStatus(): Int{
        val notificationManager =  getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager ;

        // Check if the notification policy access has been granted for the app.
//        if (!notificationManager.isNotificationPolicyAccessGranted()) {
//            val intent: Intent =
//                Intent(android.provider.Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
//            startActivity(intent)
//        }

        return notificationManager.getCurrentInterruptionFilter()
        
    }

    private fun getImportance(): List<Map<String, Any>>? {

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channels = notificationManager.notificationChannels
        return  channels.map { channel ->
            mapOf(
                "id" to channel.id,
                "name" to channel.name,
                "importance" to channel.importance,
                "canBypassDnd" to channel.canBypassDnd(),
                "description" to (channel.description ?: "")
            )
        }

    }


    private fun canBypassDnd(): Boolean {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channels = notificationManager.notificationChannels

        // Assuming you want to check for a specific channel, e.g., "its_urgent_notifications"
        val channel = channels.find { it.id == "its_urgent_notifications" }

        // Return true if the channel exists and can bypass DND, otherwise false
        return channel?.canBypassDnd() ?: false
    }
}
