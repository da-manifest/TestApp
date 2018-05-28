//
//  AppDelegate.swift
//  Login
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

var vkDelegate: VKDelegate?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        vkDelegate = VKDelegate()
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

