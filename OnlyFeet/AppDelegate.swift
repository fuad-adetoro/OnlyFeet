//
//  AppDelegate.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import FirebaseCore 
import UIKit.UIScrollView

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UIScrollView.appearance().keyboardDismissMode = .interactive

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Terminating")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Resigning")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("In the Background")
    }
}
