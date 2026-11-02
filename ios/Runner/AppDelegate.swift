import Flutter
import Measure
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "MEASURE_API_KEY") as? String ?? ""
    let apiUrl = Bundle.main.object(forInfoDictionaryKey: "MEASURE_API_URL") as? String ?? ""
    if !apiKey.isEmpty, !apiUrl.isEmpty {
      // Self-hosted measure.sh — apiUrl is your ingest/API base, not measure.sh cloud.
      let clientInfo = ClientInfo(apiKey: apiKey, apiUrl: apiUrl)
      Measure.initialize(with: clientInfo, config: BaseMeasureConfig())
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
