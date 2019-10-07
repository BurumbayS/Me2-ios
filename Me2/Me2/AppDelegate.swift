//
//  AppDelegate.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/29/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import FBSDKCoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure Facebook sign-in
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Configure Google sign-in
        GIDSignIn.sharedInstance().clientID = "46834004232-eqvmijmtp0n28aitrkcmtpqldso57j1u.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = SocialMedia.shared
        
        //Set root View Controller
        window?.rootViewController = Storyboard.signInOrUpViewController()
        
        //Configure IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Готово"
        IQKeyboardManager.shared.toolbarTintColor = Color.blue
        
        //Configure Google maps
        GMSServices.provideAPIKey("AIzaSyC5GiPTioS-d3vyjC1CPNcoPndElqVm8Kg")
        GMSPlacesClient.provideAPIKey("AIzaSyC5GiPTioS-d3vyjC1CPNcoPndElqVm8Kg")
        
        //Configure Firebase
        FirebaseApp.configure()
        
        window?.makeKeyAndVisible()
        return true
    }

    //Google SignIn
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        
        print("Scheme: \(scheme)")
        
        if scheme.contains("fb") {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        } else if scheme.contains("google") {
            return GIDSignIn.sharedInstance().handle(url)
        }
        
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

