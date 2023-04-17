//
//  AppDelegate.swift
//  One-image Viewer
//
//  Created by Chen Yi-Wei on 2019/3/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

		window = UIWindow()
		window?.rootViewController = ViewController()
		window?.makeKeyAndVisible()
        return true
    }
}

