# YuviTal Life SDK - Android (Swift) Sample Integration Guide

This repository contains an **iOS Swift sample application** that demonstrates how to integrate the YuviTal Life SDK into a native iOS app.

---

## Compatibility Notice

This SDK is designed exclusively for **native mobile applications** developed using:

-   **iOS:** Swift or Objective-C

### Prerequisites

-   **Target OS:** iOS 15.5+

-   **iOS**

**Add Cloudsmith CocoaPods token to .netrc**

```swift
sed -i.bak "/^machine dl\.cloudsmith\.io/d" ~/.netrc 2>/dev/null || touch ~/.netrc
echo "\nmachine dl.cloudsmith.io login token password <CLOUDSMITH_TOKEN>" >> ~/.netrc
```

After updating `~/.netrc`, make sure its permissions are restricted:
```ruby
chmod 600 ~/.netrc
```
This is required so tools like CocoaPods will use the credentials in `.netrc`.

**Add to Podfile**

If your project doesn’t have a `Podfile` yet, create one in your Xcode project directory:
```ruby
cd <PATH_TO_YOUR_XCODE_PROJECT>
pod init
```

Add this to your `Podfile`:
```ruby
source 'https://cdn.cocoapods.org/'
# Staging yuvital-life-sdk-staging
# Production yuvital-life-sdk-production
source "https://dl.cloudsmith.io/basic/yuvital/yuvital-life-sdk-production/cocoapods/index.git"

target '<YOUR_TARGET>' do
    use_frameworks!

    pod 'YuvitalLifeSDK', '1.1.6'
end
```

Ensure your app’s **iOS Deployment Target** is set to **iOS 15.5 or later**:

- In Xcode, select your app target.
- Go to the **General** tab.
- Under **Minimum Deployments**, set **iOS 15.5** (or higher) as the Deployment Target.

Install the dependencies:
```ruby
pod install
```

**HealthKit Setup & Info.plist Configuration**


Add these keys to Info.plist

```swift
<key>NSHealthShareUsageDescription</key>
<string>We want access to your health data so we can help you track your achievements and reach your goals</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We want access to your health data so we can help you track your achievements and reach your goals</string>
<key>UIViewControllerBasedStatusBarAppearance</key>
<false/>
```

Enable HealthKit capability (Entitlements)

In **Signing & Capabilities** for your target, add **HealthKit**:

```swift
    <!-- In your .entitlements file -->
<key>com.apple.developer.healthkit</key>
<true/>
<key>com.apple.developer.healthkit.access</key>
<array>
    <string>health-records</string>
</array>
```

**User Script Sandboxing**

Xcode 15 enables User Script Sandboxing by default, which can block CocoaPods’ standard [CP] Embed Pods Frameworks script from copying the SDK’s frameworks, causing Operation not permitted build errors. To allow the SDK to be embedded correctly, you need to disable this sandboxing for your app target.

- In Xcode, select your app target.
- Open the **Build Settings** tab.
- Search for **`ENABLE_USER_SCRIPT_SANDBOXING`**.
- Set **`ENABLE_USER_SCRIPT_SANDBOXING`** to **`NO`** for all configurations (Debug/Release).

**Open The SDK Screen**

The Yuvital Life SDK provides a React Native screen with the module name **`"YuvitalLifeNativeSdk"`**. Initialize the React runtime **once**, then present this screen wherever needed in your application.

Open the SDK from any screen

**Initialize once at startup** (AppDelegate, SceneDelegate or SwiftUI App)

```swift
import YuvitalLifeSDK
import ReactBrownfield

// AppDelegate example
func application(...) -> Bool {
    // ...
    ReactNativeBrownfield.shared.bundle = ReactNativeBundle
    ReactNativeBrownfield.shared.startReactNative()
    // ...
}
```

Push onto a navigation stack:

```swift
import YuvitalLifeSDK
import ReactBrownfield

// Button example
@IBAction func openSdkTapped(_ sender: Any) {
    // Safe to call; only the first call starts the runtime
    ReactNativeBrownfield.shared.startReactNative()

    let vc = ReactNativeViewController(moduleName: "YuvitalLifeNativeSdk")
    
    // Optional: hide the navigation bar so the SDK screen appears full-screen
    navigationController?.setNavigationBarHidden(true, animated: true)

    navigationController?.pushViewController(vc, animated: true)
}
```

### Optional: Enable swipe‑back when the navigation bar is hidden

If your app hides the `UINavigationBar` (for a full‑screen look) but still wants the system
swipe‑back gesture, set the navigation controller as the delegate of its interactive
pop gesture and allow the gesture only when there is something to pop:
This keeps the SDK full‑screen while preserving the native edge-swipe back behavior.

```swift
// In AppDelegate (after creating the navigation controller)
let navigationController = UINavigationController(rootViewController: rootViewController)
navigationController.interactivePopGestureRecognizer?.delegate = navigationController

// Gesture delegate implementation
extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow swipe-back only if there is more than one view controller on the stack
        return viewControllers.count > 1
    }
}
```
