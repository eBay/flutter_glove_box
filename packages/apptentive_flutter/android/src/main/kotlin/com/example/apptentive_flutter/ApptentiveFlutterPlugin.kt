package com.example.apptentive_flutter

import com.apptentive.android.sdk.Apptentive
import io.flutter.plugin.common.FlutterException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class ApptentiveFlutterPlugin(private val registrar: Registrar) : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "apptentive_flutter")
            channel.setMethodCallHandler(ApptentiveFlutterPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) = when(call.method) {
        "engageEvent" -> engageEvent(call, result)
        else -> result.notImplemented()
    }
    private fun engageEvent(call: MethodCall, result: Result) = when(val argument = call.arguments) {
        is String -> Apptentive.engage(this.registrar.activeContext(), argument)
        else -> result.notImplemented()
    }
}
