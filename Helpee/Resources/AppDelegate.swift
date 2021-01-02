//
//  AppDelegate.swift
//  Helpee
//
//  Created by iMac on 25/12/20.
//

import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "205855543998-ahc1fdkb857bklamtl9ujlqhto83749j.apps.googleusercontent.com"
        
        return true
    }
}

