//
//  AppDelegate.swift
//  Helpee
//
//  Created by iMac on 25/12/20.
//

import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "205855543998-gpqb9osr8f0n24j9dqhat7ko2ivi1vnt.apps.googleusercontent.com"
        
        if let appLanguage = UserDefaults.standard.value(forKey: "appLanguage") as? String
        {
            if appLanguage == "en"
            {
                AppData.sharedInstance.appLanguage = "en"
            }
            else{
                AppData.sharedInstance.appLanguage = "fr"
            }
        }
        else{
            AppData.sharedInstance.appLanguage = "en"
        }
        
        //configure notification
        self.configurePushNotification()
        
        return true
    }
    
    //MARK: - Configure Push Notification
    fileprivate func configurePushNotification() {
        FirebaseApp.configure()
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                // For iOS 10 data message (sent via FCM)
                Messaging.messaging().delegate = self
            }
            
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    /*//MARK: - Configure Push Notification
    fileprivate func configurePushNotification() {
        FirebaseApp.configure()
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                // For iOS 10 data message (sent via FCM)
                Messaging.messaging().delegate = self
            }
            
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }*/
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        
        print("deviceToken ==> \(token)")
        
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        
        Messaging.messaging().apnsToken = deviceToken
        let tokenFCM = Messaging.messaging().fcmToken
        if let tokenFCM = Messaging.messaging().fcmToken
        {
            UserDefaults.standard.set(tokenFCM, forKey: "fcmToken")
        }
        else{
            UserDefaults.standard.set("", forKey: "fcmToken")
        }
        UserDefaults.standard.set(token, forKey: "device_token")
        
        print("Firebase registration token: \(tokenFCM)")
        
        //UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("deviceToken error ==>  %@", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        if (UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive) {
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        }
        
        completionHandler(.newData)
    }
    
    //for displaying notification when app is in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(notification.request.content.userInfo)
        
        if (UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive) {
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        }
        else {
            completionHandler([.sound,.alert,.badge])
        }
    }
    
    // For handling tap and user actions
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.notification.request.content.userInfo)
        //        print((response.notification.request.content.userInfo as! NSDictionary).value(forKey: "senderID") as! String)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        if (UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive) {
            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        }
        print("Push notification received: \(data)")
    }
}
extension AppDelegate :MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    {
        AppData.sharedInstance.fcm_token = fcmToken ?? ""
        NotificationCenter.default.post(name: Notification.Name("tokenAPICall"), object: nil)
        print("Firebase registration token: \(fcmToken ?? "")")
    }
}
