package com.google_mlkit_text_recognition

import androidx.annotation.NonNull
import android.content.Context
import android.graphics.BitmapFactory
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** GoogleMlKitTextRecognitionPlugin */
class GoogleMlKitTextRecognitionPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "google_mlkit_text_recognition")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "processImage" -> {
        val imagePath = call.argument<String>("imagePath")
        if (imagePath != null) {
          processImage(imagePath, result)
        } else {
          result.error("INVALID_ARGUMENT", "Image path is required", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun processImage(imagePath: String, result: Result) {
    try {
      val bitmap = BitmapFactory.decodeFile(imagePath)
      val image = InputImage.fromBitmap(bitmap, 0)
      val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)

      recognizer.process(image)
        .addOnSuccessListener { visionText ->
          val recognizedText = visionText.text
          result.success(mapOf("text" to recognizedText))
        }
        .addOnFailureListener { e ->
          result.error("RECOGNITION_ERROR", e.message, null)
        }
    } catch (e: Exception) {
      result.error("PROCESSING_ERROR", e.message, null)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
