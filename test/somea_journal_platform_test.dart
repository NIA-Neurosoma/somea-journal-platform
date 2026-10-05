
import 'package:flutter_test/flutter_test.dart';
import 'package:somea_journal_platform/somea_journal_platform.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final api = SomeaJournalPlatform();
  tearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SomeaJournalPlatform.channel, null));
  test('protected directory returns native path', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SomeaJournalPlatform.channel, (call) async => '/owned/no_backup/somea-journal-v1');
    expect(await api.protectedDirectory(), '/owned/no_backup/somea-journal-v1');
  });
  test('missing native directory fails visibly', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SomeaJournalPlatform.channel, (call) async => null);
    await expectLater(api.protectedDirectory(), throwsStateError);
  });
  test('false native protection fails visibly', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SomeaJournalPlatform.channel, (call) async => false);
    await expectLater(api.verifyProtection('/owned/file'), throwsStateError);
  });
  test('protection request contains only a path', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SomeaJournalPlatform.channel, (call) async {
      expect(call.method, 'verifyProtection'); expect(call.arguments, {'path':'/owned/file'}); return true;
    });
    await api.verifyProtection('/owned/file');
  });
}

