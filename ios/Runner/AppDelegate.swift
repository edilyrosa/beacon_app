import UIKit
import Flutter
import CoreLocation
import flutter_downloader
    
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  let locationManager = CLLocationManager()
    
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      locationManager.requestAlwaysAuthorization()
      GeneratedPluginRegistrant.register(with: self)
      FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
