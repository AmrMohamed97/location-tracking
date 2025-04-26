package com.example.ios_android_background

import android.content.Intent
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.FlutterEngine
import com.example.ios_android_background.myBackgroundLocationTracker.LocationTrackingService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannelName = "myLocationTracking"
    private val eventChannelName = "myLocationUpdates"
    private var permissionsGranted = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        checkAndRequestPermissions()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "startService") {
                    // تحقق من الصلاحيات في كل مرة قبل بدء الخدمة
                    if (hasLocationPermissions()) {
                        val intent = Intent(this, LocationTrackingService::class.java)
                        intent.action = LocationTrackingService.ACTION_START
                        startService(intent)
                        result.success("Service Started")
                    } else {
                        // إذا لم تكن الصلاحيات ممنوحة، اطلبها من المستخدم
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(
                                Manifest.permission.ACCESS_FINE_LOCATION,
                                Manifest.permission.ACCESS_COARSE_LOCATION,
                            ),
                            111
                        )
                        result.error("PERMISSION_DENIED", "Location permission not granted", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

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

    private fun checkAndRequestPermissions() {
        if (!hasLocationPermissions()) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                ),
                111
            )
        } else {
            permissionsGranted = true
        }
    }

    private fun hasLocationPermissions(): Boolean {
        return ActivityCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED ||
                ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 111) {
            permissionsGranted = grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }
        }
    }
}