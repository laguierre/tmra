import Flutter
import UIKit

public class SwiftDownloadsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "downloads_path", binaryMessenger: registrar.messenger())
    let instance = SwiftDownloadsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          if (call.method == "getDownloadsDirectory") {
              result(getDownloadsDirectory())
          } else {
              result(FlutterMethodNotImplemented)
          }
      }

      public func getDownloadsDirectory() -> String? {
          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
          return documentsPath

//              let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).map(\.path)
//              return paths.first
      }
}
