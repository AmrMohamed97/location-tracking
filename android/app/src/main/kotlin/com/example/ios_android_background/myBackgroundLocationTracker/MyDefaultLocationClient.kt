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
    fun getLocationUpdates(minDistance: Float): Flow<Location>

    class AnyException(message: String) : Exception()
}

// ... existing code ...
class MyDefaultLocationClient(
    private val context: Context,
    private val client: FusedLocationProviderClient
) : MyLocationClient {
    @SuppressLint("MissingPermission")
    @OptIn(ExperimentalCoroutinesApi::class)
    override fun getLocationUpdates(minDistance: Float): Flow<Location> {
        return callbackFlow {
            // تحقق من الصلاحيات
            if (!context.hasLocationPermissions()) {
                close(MyLocationClient.AnyException("Missing Permissions for Location"))
                return@callbackFlow
            }

            val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
            val isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
            val isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
            if (!isGpsEnabled && !isNetworkEnabled) {
                close(MyLocationClient.AnyException("GPS is disabled"))
                return@callbackFlow
            }

            // إعداد طلب الموقع مع تحديث كل متر واحد فقط
            val request = LocationRequest.Builder(1000L) // تحديث كل ثانية (لضمان التحديث حتى لو لم يتحرك)
                .setMinUpdateDistanceMeters(minDistance) // تحديث عند الحركة لمسافة معينة
                .setWaitForAccurateLocation(false)
                .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
                .build()

            val locationCallback = object : LocationCallback() {
                override fun onLocationResult(p0: LocationResult) {
                    super.onLocationResult(p0)
                    p0.locations.lastOrNull()?.let {
                        Log.i("MyDefaultLocationClient", "New Location: ${it.latitude}, ${it.longitude}")
                        launch { send(it) }
                    }
                }
            }

            client.requestLocationUpdates(request, locationCallback, Looper.getMainLooper())
            awaitClose { client.removeLocationUpdates(locationCallback) }
        }
    }

    private fun Context.hasLocationPermissions(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
                ||
                ContextCompat.checkSelfPermission(
                    this,
                    android.Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
    }
}