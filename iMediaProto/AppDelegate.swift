//
//  AppDelegate.swift
//
//
//  Created by Habib on 7/1/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - Constants
    
    private struct Storyboard {
        static let ShowQuoteSegueIdentifier = "ShowQuote"
    }
    
    // MARK: - Properties
    
    var window: UIWindow?
    var wantsToDisplayQuoteOfTheDay = false
    
    // MARK: - Class properties
    
    static var shared: AppDelegate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //        window = UIWindow()
        //        window?.makeKeyAndVisible()
        //        UNUserNotificationCenter.current().delegate = self
        //        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { _,_ in }
        //        AppDelegate.shared = self
        
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // MARK: - User notification center delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions())
    }
    
}
