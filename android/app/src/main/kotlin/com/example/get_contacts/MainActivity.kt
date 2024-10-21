package com.progressiveitservices.Shubhvite

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.progressiveitservices.Shubhvite/settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "openSettings") {
                openSettings()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openSettings() {
        val intent = Intent(Settings.ACTION_SECURITY_SETTINGS)
        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            // Handle the case where the settings action is not available
            // For example, you could log an error or show a message to the user
        }
    }
}
