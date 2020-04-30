package com.example.apptentive_flutter_example

import android.app.Application
import com.apptentive.android.sdk.Apptentive
import com.apptentive.android.sdk.ApptentiveConfiguration
import io.flutter.app.FlutterApplication

class YourApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        val configuration = ApptentiveConfiguration("App key", "app signature")
        Apptentive.register(this, configuration)
    }
}
