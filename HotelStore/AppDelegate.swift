//
//  AppDelegate.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 10.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import UIKit
import Stripe
import UserNotifications
import Locksmith
import YandexMobileMetrica
import PyrusServiceDesk

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        application.applicationIconBadgeNumber = 0
        
        Stripe.setDefaultPublishableKey(StripeKeys.publishable_key_not_test)
        STPTheme.default().accentColor = UIColor(red: 182/255, green: 9/255, blue: 73/255, alpha: 1)
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.HotelStore"
        registerForPushNotifications()
        // Override point for customization after application launch.
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "1f5731d4-b1f0-4b99-9b27-2d70f1cfe36d")
        YMMYandexMetrica.activate(with: configuration!)
        PyrusServiceDesk.createWith("FMsCcblgy1pDRyIxUEgIzCllz-NCbS0wwgBlCXM9CemtHr50Laa3UlO4TkiH0CKIaJqP4v~bfxz6pDuTTHaMIJwBRxw27w-8W08HnF0kPXPENZiLmxs6oxKLSJE1SJ3MOTzT3g==")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
        (granted, error) in
        print("Permission granted: \(granted)")
        
        guard granted else { return }
        self.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        DataModel.sharedData.deviceToken = token
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
}

