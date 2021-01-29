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
    
    //MARK: - UIApplicationDelegate Methods
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print message ID.
        //    if let messageID = userInfo[gcmMessageIDKey]
        //    {
        //      print("Message ID: \(messageID)")
        //    }
        
        // Print full message.
        
        print(userInfo)
        
        //    let code = String.getString(message: userInfo["code"])
        guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
        guard let alert = aps["alert"] as? String else { return }
        //    guard let body = alert["body"] as? String else { return }
        
        completionHandler([.alert,.badge,.sound])
    }
    
    // Handle notification messages after display notification is tapped by the user.
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        completionHandler()
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
