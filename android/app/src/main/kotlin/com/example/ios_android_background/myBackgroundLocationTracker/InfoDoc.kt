package com.example.ios_android_background.myBackgroundLocationTracker

//[0]add dependencies in gradle [ implementation(libs.play.services.location)]
//[1]create [MyLocationClient class] & [MyDefaultLocationClient class]
//[2]create [LocationTrackingService ] and add it in manifest
//[3]add permissions in manifest
                        /*<uses-permission android:name="android.permission.INTERNET" />
                        <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
                        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
                        <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
                        <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
                        <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
                        <uses-permission android:name="android.permission.WAKE_LOCK" />
                        <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
                        <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />*/
//[4]in main activity
//  (1)request permissions
//                  android.Manifest.permission.ACCESS_FINE_LOCATION,
//                  android.Manifest.permission.ACCESS_COARSE_LOCATION,
//                  android.Manifest.permission.POST_NOTIFICATIONS,
//  (2)create method channel to start service
//
//[5] create channel to start service