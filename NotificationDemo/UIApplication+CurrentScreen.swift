//
//  UIApplication+CurrentScreen.swift
//  NotificationDemo
//
//  Created by Mariano Battaglia on 17/01/2024.
//

import UIKit

extension UIApplication {
  static var windowRootController: UIViewController? {
    if #available(iOS 13.0, *) {
      let windowScene = UIApplication.shared
        .connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first
      
      if let window = windowScene as? UIWindowScene {
        return window.windows.last?.rootViewController
      }
      
      return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    } else {
      return UIApplication.shared.keyWindow?.rootViewController
    }
  }
  
  func currentScreen(controller: UIViewController? = windowRootController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return currentScreen(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return currentScreen(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return currentScreen(controller: presented)
    }
    return controller
  }
}
