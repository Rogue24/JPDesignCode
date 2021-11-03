//
//  AppDelegate.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/9/14.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        return true
    }
    
}
