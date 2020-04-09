//
//  AppDelegate.swift
//  LotteryAlarm
//
//  Created by 中口翔太 on 2020/03/24.
//  Copyright © 2020 中口翔太. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var notificationGranted = true
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //許可を出すコード↓
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {

        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]; UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
        } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert,.sound])
        {
        (granted, error) in
        self.notificationGranted = granted
        if let error = error {
        print("granted, but Error in notification permission:\(error.localizedDescription)")
        }}
        //許可を出すコード↑
        //フォアグランド状態でも通知が送られる
        UNUserNotificationCenter.current().delegate = self        
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
    
    //メッセージを受け取っと時の反応↓
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // Print message ID.
    if let messageID = userInfo["gcm.message_id"] {
    print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // Print message ID.
    if let messageID = userInfo["gcm.message_id"] {
    print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler(UIBackgroundFetchResult.newData)
    }
    //メッセージを受け取っと時の反応↑
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void) {
//
//            //　windowを生成
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            //　Storyboardを指定
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            // Viewcontrollerを指定
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "come")
//            // rootViewControllerに入れる
//            self.window?.rootViewController = initialViewController
//            // 表示
//            self.window?.makeKeyAndVisible()
//
//        return
//        print("プシュ通知から1")
//        return
//
//
//            completionHandler()
//    }
    
    
}


//フォアグランド状態でも通知が送られる
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([ .badge, .sound, .alert ])
    }
}






