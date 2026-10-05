import Flutter
import Foundation

public class SomeaJournalPlatformPlugin: NSObject, FlutterPlugin {
  private let queue = DispatchQueue(label: "ge.somea.journal-privacy")
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ge.somea/journal_privacy", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SomeaJournalPlatformPlugin(), channel: channel)
  }
  private func mark(_ url: URL) throws {
    var target = url
    var values = URLResourceValues()
    values.isExcludedFromBackup = true
    try target.setResourceValues(values)
    try FileManager.default.setAttributes([.protectionKey: FileProtectionType.complete], ofItemAtPath: target.path)
    let attributes = try FileManager.default.attributesOfItem(atPath: target.path)
    guard attributes[.protectionKey] as? FileProtectionType == FileProtectionType.complete else {
      throw NSError(domain: "journal", code: 5)
    }
    guard try target.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup == true else {
      throw NSError(domain: "journal", code: 1)
    }
  }
  private func root() throws -> URL {
    let support = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let folder = support.resolvingSymlinksInPath().appendingPathComponent("somea-journal-v1", isDirectory: true)
    guard folder.standardizedFileURL.path == folder.resolvingSymlinksInPath().path else {
      throw NSError(domain: "journal", code: 2)
    }
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false)
    try mark(folder)
    return folder
  }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    queue.async {
      do {
        let value: Any
        switch call.method {
        case "protectedDirectory": value = try self.root().path
        case "verifyProtection":
          guard let args = call.arguments as? [String: Any], let path = args["path"] as? String else {
            throw NSError(domain: "journal", code: 3)
          }
          let folder = try self.root()
          let target = URL(fileURLWithPath: path).standardizedFileURL
          let owned = "^(?:[a-f0-9]{64}(?:\\.[0-9]{16})?\\.cipher(?:\\.[A-Za-z0-9_=-]+\\.pending)?|\\.journal\\.lock)$"
          guard target.path == target.resolvingSymlinksInPath().path,
                target.path == folder.path || (target.deletingLastPathComponent().path == folder.path &&
                target.lastPathComponent.range(of: owned, options: .regularExpression) != nil),
                FileManager.default.fileExists(atPath: target.path) else {
            throw NSError(domain: "journal", code: 4)
          }
          try self.mark(target); value = true
        default:
          DispatchQueue.main.async { result(FlutterMethodNotImplemented) }; return
        }
        DispatchQueue.main.async { result(value) }
      } catch {
        DispatchQueue.main.async { result(FlutterError(code: "JOURNAL_PROTECTION_FAILED", message: "Journal protection unavailable", details: nil)) }
      }
    }
  }
}


