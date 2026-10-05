package ge.somea.somea_journal_platform
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test
internal class SomeaJournalPlatformPluginTest {
    @Test fun unknownMethodsAreNotImplemented() {
        val result = Mockito.mock(MethodChannel.Result::class.java)
        SomeaJournalPlatformPlugin().onMethodCall(MethodCall("arbitraryWrite", null), result)
        Mockito.verify(result).notImplemented()
        Mockito.verifyNoMoreInteractions(result)
    }
    @Test fun malformedProtectionRequestFailsWithoutPathLeak() {
        val result = Mockito.mock(MethodChannel.Result::class.java)
        SomeaJournalPlatformPlugin().onMethodCall(MethodCall("verifyProtection", null), result)
        Mockito.verify(result).error("JOURNAL_PROTECTION_FAILED", "Journal protection unavailable", null)
        Mockito.verifyNoMoreInteractions(result)
    }
}
