//
//  AppDelegate.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/10.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import CoreData
// Firebase
import Firebase
import FirebaseMessaging
import UserNotifications

import IQKeyboardManagerSwift

import GoogleMobileAds

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    lazy var db = Firestore.firestore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 키보드
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // 네비게이션바 밑에 하단 줄 제거
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().shadowImage = nil
        
        // 알림 권한 요청
        // TODO : 나중에 권한 요청 뷰 따로 만들 것
        requestAuthorizationForRemotePushNotification()
        FirebaseApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        /*
         FMC 설정
         */
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        
        /*
         스플래쉬 스크린 설정
         */
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Splash", bundle: .main)
        let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC")
        self.window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    /*
     FCM Function
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "dimodamo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


/*
 유저 알림 확장
 */
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
        completionHandler([.banner, .sound])
    }
    
    // 사용자에게 푸시 권한을 요청
    func requestAuthorizationForRemotePushNotification() {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // granted가 true로 떨어지면 푸시를 받을 수 있습닏.
        }
    }
}

/*
 FCM 확장
 */
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        let user = Auth.auth().currentUser
        if let userUID = user?.uid {
            let userFcmIdDB = db.collection("FcmId").document("\(userUID)")
            print("## FCMIDDB : \(userFcmIdDB)")
            userFcmIdDB.setData(["FCM" : "\(fcmToken)"], merge: true)
        }
    }
}
