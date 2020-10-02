//
//  AppDelegate.swift
//  dimodamo
//
//  Created by JJIKKYU on 2020/09/10.
//  Copyright © 2020 JJIKKYU. All rights reserved.
//

import UIKit
import CoreData

// KAKAO
//import RxKakaoSDKCommon
//import KakaoSDKAuth
//import RxKakaoSDKAuth
//
//import KakaoSDKUser
//import RxKakaoSDKUser

// Firebase
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
//        RxKakaoSDKCommon.initSDK(appKey: "341ee584089327e9570b298fd3d21b5b")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // 로그인 중일 때는 메인으로
        // 로그아웃 상태일 때는 로그인 화면으로
        if let user = Auth.auth().currentUser {
            print("현재 로그인중입니다")
            print("\(Auth.auth().currentUser?.uid)")
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let mainVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        } else {
            print("로그아웃 상태입니다")
            let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: .main)
            let loginVC: UIViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginMain")
            self.window?.rootViewController = loginVC
            self.window?.makeKeyAndVisible()
        }
        
        
        
//        print(self.window?.rootViewController)
//        
//        if let currentRoot = self.window?.rootViewController {
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            let artificialRoot = storyboard.instantiateViewController(withIdentifier: "LoginMain")
//            currentRoot.present(artificialRoot, animated: true, completion: nil)
//        }
//        
        return true
    }
    
    // MARK: KAKAO
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if (AuthApi.isKakaoTalkLoginUrl(url)) {
//            return AuthController.handleOpenUrl(url: url)
//        }

        return false
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

