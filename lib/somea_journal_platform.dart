import 'package:flutter/services.dart';

/// Native privacy capabilities only. Never sends journal values or keys.
class SomeaJournalPlatform {
  static const channel = MethodChannel('ge.somea/journal_privacy');
  Future<String> protectedDirectory() async {
    final path = await channel.invokeMethod<String>('protectedDirectory');
    if (path == null || path.isEmpty) throw StateError('journal-directory-unavailable');
    return path;
  }
  Future<void> verifyProtection(String path) async {
    if (await channel.invokeMethod<bool>('verifyProtection', {'path': path}) != true) {
      throw StateError('journal-protection-unverified');
    }
  }
}
