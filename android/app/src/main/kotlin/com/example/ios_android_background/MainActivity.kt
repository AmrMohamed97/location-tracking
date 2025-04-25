package com.example.ios_android_background

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import androidx.core.app.ActivityCompat
import android.util.Log
import com.example.ios_android_background.myBackgroundLocationTracker.Counter
import com.example.ios_android_background.myBackgroundLocationTracker.LocationTrackingService


class MainActivity : FlutterActivity() {
    private val CHANNEL = "myLocationTracking"
    private val countChannel = "getCountChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                android.Manifest.permission.ACCESS_FINE_LOCATION,
                android.Manifest.permission.ACCESS_COARSE_LOCATION,
                android.Manifest.permission.POST_NOTIFICATIONS,
            ),
            111
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->



            if (call.method == "startService") {

                try {
                    val intent = Intent(this, LocationTrackingService::class.java)
                    startService(intent)
                    Intent(applicationContext, LocationTrackingService::class.java).apply {
                        action = LocationTrackingService.ACTION_START
                        startService(this)
                    }
                }catch (e:Exception){ Log.i("",e.toString()) }

                result.success(1)
            }

            else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, countChannel).setMethodCallHandler { call, result ->



            if (call.method == "getCount") {



                val count=  Counter(context).getFunctionCount()

                result.success(count.toString())
            }





            else {
                result.notImplemented()
            }
        }
    }
}
