package com.example.ios_android_background.myBackgroundLocationTracker




import android.content.Context
import android.content.SharedPreferences
import android.util.Log

// Initialize SharedPreferences
class Counter(context: Context) {
    private val sharedPreferences: SharedPreferences = context.getSharedPreferences("FunctionPrefs", Context.MODE_PRIVATE)

    // Increment the function run count
    fun incrementFunctionCount() {
        val currentCount = sharedPreferences.getInt("count", 0)
        sharedPreferences.edit().putInt("count", currentCount + 1).apply()
        Log.i("", sharedPreferences.getInt("count", 0).toString())
    }

    // Retrieve the function run count
    fun getFunctionCount(): Int {
        return sharedPreferences.getInt("count", 0)
    }


}