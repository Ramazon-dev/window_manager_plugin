package com.example.window_manager

import android.app.Activity
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class WindowManagerPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var activity: Activity
    private lateinit var channel: MethodChannel
    var isSecureFlagSet = false;

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "window_manager")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "blockScreenShot" -> {
                val isFlagSet = setSecureFlag()
                result.success("called blockScreenShot")
            }

            "unblockScreenShot" -> {
                val isFlagRemoved = removeSecureFlag()
                result.success("called unblockScreenShot")
            }

            "isBlockScreenShot" -> {
                result.success(isBlockScreenShot())
            }

            "enablePrivacyScreen" -> {
                val isFlagSet = setSecureFlag()
                result.success("called enablePrivacyScreen")
            }

            "disablePrivacyScreen" -> {
                val isFlagRemoved = removeSecureFlag()
                result.success("called disablePrivacyScreen")
            }

            else -> {
                result.notImplemented()
            }
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        onAttachedToActivity(activityPluginBinding)
    }

    override fun onDetachedFromActivity() {}


    private fun setSecureFlag(): Boolean {
        try {
            activity.window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE,
            )
            isSecureFlagSet = true
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun removeSecureFlag(): Boolean {
        try {
            activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            isSecureFlagSet = false
            return true
        } catch (_: Exception) {
            return false
        }
    }

    private fun isBlockScreenShot(): Boolean {
        return isSecureFlagSet
    }

}


