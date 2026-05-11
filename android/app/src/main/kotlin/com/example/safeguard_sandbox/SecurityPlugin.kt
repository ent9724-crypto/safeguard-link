package com.example.safeguard_sandbox

import android.app.Activity
import android.content.Context
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class SecurityPlugin(private val activity: Activity) {
    companion object {
        const val CHANNEL = "safeguard_link/security"
    }

    fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecureMode" -> {
                    enableSecureMode()
                    result.success(true)
                }
                "checkScreenMirroring" -> {
                    val isMirroring = isScreenMirroring()
                    result.success(isMirroring)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun enableSecureMode() {
        activity.runOnUiThread {
            activity.window.addFlags(
                WindowManager.LayoutParams.FLAG_SECURE
            )
        }
    }

    private fun isScreenMirroring(): Boolean {
        return try {
            // Check if screen recording or mirroring is active
            val displayManager = activity.getSystemService(Context.DISPLAY_SERVICE) as android.hardware.display.DisplayManager
            val displays = displayManager.displays
            
            // Check for multiple displays (potential mirroring)
            displays.size > 1
        } catch (e: Exception) {
            false
        }
    }
}
