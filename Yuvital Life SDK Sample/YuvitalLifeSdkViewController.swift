import UIKit
import ReactBrownfield

final class YuvitalLifeSdkViewController: UIViewController, UIGestureRecognizerDelegate {

  private weak var previousPopDelegate: UIGestureRecognizerDelegate?
  private var previousNavBarHidden: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()

    let sdkVC = ReactNativeViewController(moduleName: "YuvitalLifeNativeSdk")

    addChild(sdkVC)
    view.addSubview(sdkVC.view)
    sdkVC.view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      sdkVC.view.topAnchor.constraint(equalTo: view.topAnchor),
      sdkVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      sdkVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      sdkVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    sdkVC.didMove(toParent: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if let nav = navigationController {
      previousNavBarHidden = nav.isNavigationBarHidden
      nav.setNavigationBarHidden(true, animated: animated)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard let nav = navigationController,
      let gesture = nav.interactivePopGestureRecognizer
    else { return }

    previousPopDelegate = gesture.delegate
    gesture.delegate = self
    gesture.isEnabled = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if let nav = navigationController {
      nav.setNavigationBarHidden(previousNavBarHidden, animated: animated)
    }

    if let nav = navigationController,
      let gesture = nav.interactivePopGestureRecognizer
    {
      gesture.delegate = previousPopDelegate
    }
  }

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return navigationController?.viewControllers.count ?? 0 > 1
  }
}
