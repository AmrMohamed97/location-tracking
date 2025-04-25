package com.example.ios_android_background.myBackgroundLocationTracker

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.os.Looper
import android.util.Log
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.launch


interface MyLocationClient {
    fun getLocationUpdates(interval: Long): Flow<Location>

    class AnyException(message: String) : Exception()
}


class MyDefaultLocationClient(
    private val context: Context,
    private val client: FusedLocationProviderClient
) : MyLocationClient {
    @SuppressLint("MissingPermission")
    @OptIn(ExperimentalCoroutinesApi::class)
    override fun getLocationUpdates(interval: Long): Flow<Location> {
        return callbackFlow {


            //--------------------------------------------------------------------------------------------------------
            /// check permissions
            if (!context.hasLocationPermissions()) {
                throw MyLocationClient.AnyException("Missing Permissions for Location")
            }
            val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
            val isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
            val isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
            if (!isGpsEnabled && !isNetworkEnabled) {
                throw MyLocationClient.AnyException("GPS is disabled")
            }
            //--------------------------------------------------------------------------------------------------------


            //--------------------------------------------------------------------------------------------------------
            /// create location tracker
            val request = LocationRequest.Builder(interval)
                .setMinUpdateDistanceMeters(1f)
                .setIntervalMillis(1L)
                .setWaitForAccurateLocation(false)
                .setPriority(100)
                .build()
            //--------------------------------------------------------------------------------------------------------


            //--------------------------------------------------------------------------------------------------------
            //location callback
            val locationCallback = object : LocationCallback() {
                override fun onLocationResult(p0: LocationResult) {
                    super.onLocationResult(p0)
                    p0.locations.lastOrNull()?.let {
                        Log.i("", p0.locations.toString())
                        Counter(context).incrementFunctionCount()
                        //for notifications
                        launch { send(it) }

                    }
                }
            }
            //--------------------------------------------------------------------------------------------------------


            //request location updates
            client.requestLocationUpdates(request, locationCallback, Looper.getMainLooper())


            //remove location updates
            awaitClose { client.removeLocationUpdates(locationCallback) }

        }
    }


    //check permissions
    private fun Context.hasLocationPermissions(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
                &&
                ContextCompat.checkSelfPermission(
                    this,
                    android.Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
    }

}