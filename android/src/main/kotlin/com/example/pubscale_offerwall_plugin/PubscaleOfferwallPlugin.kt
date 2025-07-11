package com.example.pubscale_offerwall_plugin

import android.app.Activity
import android.content.Context
import android.util.Log
import com.pubscale.sdkone.offerwall.OfferWall
import com.pubscale.sdkone.offerwall.OfferWallConfig
import com.pubscale.sdkone.offerwall.models.OfferWallInitListener
import com.pubscale.sdkone.offerwall.models.OfferWallListener
import com.pubscale.sdkone.offerwall.models.Reward
import com.pubscale.sdkone.offerwall.models.errors.InitError
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PubscaleOfferwallPlugin */
class PubscaleOfferwallPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var currActivity: Activity? = null

    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pubscale_offerwall_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "pubscale_offerwall_plugin/events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
        Log.d("PSPlugin", "Plugin attached to engine")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initializeOfferwall" -> {
                val appKey: String = call.argument<String>("app_key") ?: ""
                val uniqueId: String? = call.argument<String>("unique_id")
                val sandbox: Boolean = call.argument<Boolean>("sandbox") == true
                val fullscreen: Boolean = call.argument<Boolean>("fullscreen") == true

                val offerwallConfigBuilder = OfferWallConfig.Builder(context = context, appKey)
                if (!uniqueId.isNullOrEmpty()) {
                    offerwallConfigBuilder.setUniqueId(uniqueId)
                }
                offerwallConfigBuilder.setSandboxEnabled(sandbox).setFullscreenEnabled(fullscreen)
                OfferWall.init(offerwallConfigBuilder.build(), object : OfferWallInitListener {
                    override fun onInitSuccess() {
                        Log.d("PSOfferwall", "Offerwall init success")
                        eventSink?.success(mapOf("event" to "offerwall_init_success"))
                        result.success("Pubscale init success")
                    }

                    override fun onInitFailed(error: InitError) {
                        Log.d("PSOfferwall", "Offerwall init failed. ${error.message}")
                        eventSink?.success(
                            mapOf(
                                "event" to "offerwall_init_failed",
                                "error" to error.message
                            )
                        )
                        result.success("Pubscale init failed. Reason: ${error.message}")
                    }
                })
            }

            "launchOfferwall" -> {
                if (currActivity == null) {
                    result.error("PS ERROR", "Activity not attached", "Activity not attached")
                    return
                }
                OfferWall.launch(currActivity!!, object : OfferWallListener {
                    override fun onOfferWallShowed() {
                        Log.d("PSOfferwall", "Offerwall showed")
                        eventSink?.success(mapOf("event" to "offerwall_showed"))
                        result.success("Offerwall showed")
                    }

                    override fun onOfferWallClosed() {
                        Log.d("PSOfferwall", "Offerwall closed")
                        eventSink?.success(mapOf("event" to "offerwall_closed"))
                    }

                    override fun onRewardClaimed(reward: Reward) {
                        Log.d("PSOfferwall", "Offerwall reward claimed: ${reward.amount}")
                        eventSink?.success(
                            mapOf(
                                "event" to "offerwall_reward",
                                "amount" to reward.amount,
                                "token" to reward.token,
                                "currency" to reward.currency
                            )
                        )
                    }

                    override fun onFailed(message: String) {
                        Log.d("PSOfferwall", "Offerwall launch failed")
                        eventSink?.success(mapOf("event" to "offerwall_failed"))
                        result.error(
                            "PS ERROR",
                            "Offerwall launch failed. Reason: $message",
                            message
                        )
                    }
                })
            }

            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("PSPlugin", "Plugin detached from engine")
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
    }

    override fun onAttachedToActivity(p0: ActivityPluginBinding) {
        currActivity = p0.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {
        currActivity = null
    }
}
