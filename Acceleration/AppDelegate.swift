//
//  AppDelegate.swift
//  Acceleration
//
//  Created by Igor Łopatka on 07/03/2023.
//

import Foundation
import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    print("Did finish launching with options")
    return true
  }

}
