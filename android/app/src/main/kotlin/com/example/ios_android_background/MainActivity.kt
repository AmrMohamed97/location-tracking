package com.example.ios_android_background

import android.content.Intent
import com.example.ios_android_background.myBackgroundLocationTracker.LocationTrackingService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannelName = "myLocationTracking"
    private val eventChannelName = "myLocationUpdates"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel for starting the service
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "startService") {
                    val intent = Intent(this, LocationTrackingService::class.java)
                    intent.action = LocationTrackingService.ACTION_START
                    startService(intent)
                    result.success("Service Started")
                } else {
                    result.notImplemented()
                }
            }

        // EventChannel for location updates
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    LocationTrackingService.eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    LocationTrackingService.eventSink = null
                }
            })
    }
}