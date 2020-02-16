//
//  AppDelegate.swift
//  AlarmApp
//
//  Created by shendenkov23 on 13.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    configureNotifications()
    
    return true
  }
  
  private func configureNotifications() {
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { _, _ in }
  }
}
