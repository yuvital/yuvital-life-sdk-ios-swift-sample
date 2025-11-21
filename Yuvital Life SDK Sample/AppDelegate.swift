import UIKit
import ReactBrownfield
import YuvitalLifeSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    ReactNativeBrownfield.shared.bundle = ReactNativeBundle
    ReactNativeBrownfield.shared.startReactNative()

    let window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = RootViewController()
    let navigationController = UINavigationController(rootViewController: rootViewController)
    window.rootViewController = navigationController
    window.overrideUserInterfaceStyle = .light
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
