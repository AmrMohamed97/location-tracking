package com.example.ios_android_background.myBackgroundLocationTracker



import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.example.ios_android_background.R
import com.google.android.gms.location.LocationServices
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class LocationTrackingService: Service() {

    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private lateinit var  myLocationClient: MyLocationClient

    override fun onBind(p0: Intent?): IBinder? { return null }



    override fun onCreate() {
        super.onCreate()

        //[1]create notification channel
        createNotificationChannel()



        //[2]create location client
        myLocationClient = MyDefaultLocationClient(applicationContext, LocationServices.getFusedLocationProviderClient(applicationContext))



    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when(intent?.action){
            ACTION_START -> start()
            ACTION_STOP -> stop()
        }
        return super.onStartCommand(intent, flags, startId)
    }

    private fun start(){
        Log.i("","Start Service")
        print("Start Service")


        //-----------------------------------------------------------------------------------------------------
        //[]edit notification content
        val notification = NotificationCompat.Builder(this, "location")
            .setContentTitle("Tracking Location")
            .setContentText("Location: null")
            .setSmallIcon(R.drawable.ic_launcher_background)
            .setOngoing(true).setPriority(100)
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        //-----------------------------------------------------------------------------------------------------







        //-----------------------------------------------------------------------------------------------------
        // create location tracker and get location updates
        myLocationClient.getLocationUpdates(1L)
            .catch { e -> e.printStackTrace() }
            .onEach {
                val lat = it.latitude.toString()
                val long = it.longitude.toString()
                val updateNotification = notification.setContentText("Location: ($lat, $long)")
                notificationManager.notify(1, updateNotification.build())




                // Get the SharedPreferences instance
                val sharedPreferences = getSharedPreferences("MyPreferences", Context.MODE_PRIVATE)
                val editor = sharedPreferences.edit()

                 var count = sharedPreferences.getInt("count", 0)

                 if (sharedPreferences.contains("count")) {
                    count += 1
                    editor.putInt("count", count)
                } else {
                     count = 1
                    editor.putInt("count", count)
                }

                 editor.apply()

                 println("count: $count")





            }
            .launchIn(serviceScope)
        //-----------------------------------------------------------------------------------------------------






        startForeground(1, notification.build())
    }

    private fun stop(){
        Log.i("","stop service")
        stopForeground(true)
        stopSelf()
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.i("","onDestroy")
        serviceScope.cancel()
    }

    companion object{
        const val ACTION_START = "ACTION_START"
        const val ACTION_STOP = "ACTION_STOP"
    }


    private fun createNotificationChannel(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("location", "location", NotificationManager.IMPORTANCE_HIGH)
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)



        }
    }
}