//
//  AppDelegate.swift
//  One com comments
//
//  Created by Mihail Stevcev on 11/27/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var applicationFlowCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
    
        self.window = window
        
        LoginView.appearance().sloganTextColor = UIColor.white
        LoginView.appearance().sloganFont = UIFont.boldSystemFont(ofSize: 24.0)
        LoginView.appearance().errorTextColor = UIColor.red
        LoginView.appearance().errorFont = UIFont.systemFont(ofSize: 15.0)
        LoginView.appearance().loginButtonTextColor = UIColor.white
        LoginView.appearance().loginButtonFont = UIFont.boldSystemFont(ofSize: 17.0)
        
        CommentCell.appearance().usernameColor = UIColor(red: 7.0 / 255.0, green: 35.0 / 255.0, blue: 62.0 / 255.0, alpha: 1.0)
        CommentCell.appearance().usernameFont = UIFont.boldSystemFont(ofSize: 18.0)
        CommentCell.appearance().dateColor = UIColor(red: 137.0 / 255.0, green: 137.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
        CommentCell.appearance().dateFont = UIFont.systemFont(ofSize: 13.0)
        CommentCell.appearance().commentColor = UIColor(red: 137.0 / 255.0, green: 137.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
        CommentCell.appearance().commentFont = UIFont.systemFont(ofSize: 17.0)
        CommentCell.appearance().likeColor = UIColor(red: 137.0 / 255.0, green: 137.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
        CommentCell.appearance().likeFont = UIFont.systemFont(ofSize: 15.0)
        CommentCell.appearance().shareColor = UIColor(red: 137.0 / 255.0, green: 137.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
        CommentCell.appearance().shareFont = UIFont.systemFont(ofSize: 15.0)
        CommentCell.appearance().deleteColor = UIColor(red: 220.0 / 255.0, green: 38.0 / 255.0, blue: 65.0 / 255.0, alpha: 1.0)
        CommentCell.appearance().deleteFont = UIFont.systemFont(ofSize: 15.0)
        
        
        self.applicationFlowCoordinator = ApplicationFlowCoordinator(window: window)
        self.applicationFlowCoordinator.start()
        
        return true
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

