package com.example.ios_android_background.myBackgroundLocationTracker

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import com.google.android.gms.location.LocationServices
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

// ... existing code ...
class LocationTrackingService : Service() {

    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private lateinit var myLocationClient: MyLocationClient

    companion object {
        const val ACTION_START = "ACTION_START"
        const val ACTION_STOP = "ACTION_STOP"
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        myLocationClient = MyDefaultLocationClient(
            applicationContext,
            LocationServices.getFusedLocationProviderClient(applicationContext)
        )
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> start()
            ACTION_STOP -> stop()
        }
        return START_STICKY
    }

    private fun start() {
        Log.i("LocationTrackingService", "Start Service")
        // تأكد من أن الصلاحيات موجودة قبل البدء
        myLocationClient.getLocationUpdates(1f)
            .catch { e -> e.printStackTrace() }
            .onEach { location ->
                val lat = location.latitude
                val long = location.longitude
                val locationString = "Lat: $lat, Long: $long"
                Log.i("LocationTrackingService", locationString)
               android.os.Handler(android.os.Looper.getMainLooper()).post {
    eventSink?.success(locationString)
}
            }
            .launchIn(serviceScope)
    }

    private fun stop() {
        Log.i("LocationTrackingService", "Stop Service")
        stopForeground(true)
        stopSelf()
    }

    override fun onDestroy() {
        super.onDestroy()
        serviceScope.cancel()
    }
}
