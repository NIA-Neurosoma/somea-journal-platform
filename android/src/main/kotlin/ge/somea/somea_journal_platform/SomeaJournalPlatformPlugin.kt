package ge.somea.somea_journal_platform

import android.content.Context
import java.io.File
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

/** No networking, values, keys, or arbitrary filesystem operations. */
class SomeaJournalPlatformPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val owned = Regex("(?:[a-f0-9]{64}(?:\\.[0-9]{16})?\\.cipher(?:\\.[A-Za-z0-9_=-]+\\.pending)?|\\.journal\\.lock)")
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "ge.somea/journal_privacy",
            StandardMethodCodec.INSTANCE, binding.binaryMessenger.makeBackgroundTaskQueue())
        channel.setMethodCallHandler(this)
    }
    private fun root(): File {
        val parent = context.noBackupFilesDir.canonicalFile
        val folder = File(parent, "somea-journal-v1")
        check(folder.canonicalFile.parentFile == parent)
        check(folder.isDirectory || folder.mkdir())
        check(folder.canonicalFile == folder.absoluteFile)
        return folder
    }
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "protectedDirectory" -> result.success(root().path)
                "verifyProtection" -> {
                    val path = call.argument<String>("path") ?: error("invalid-path")
                    val folder = root()
                    val file = File(path)
                    check(file.absoluteFile == file.canonicalFile)
                    check(file == folder || (file.parentFile == folder && owned.matches(file.name)))
                    check(file.exists())
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        } catch (_: Exception) {
            result.error("JOURNAL_PROTECTION_FAILED", "Journal protection unavailable", null)
        }
    }
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

