//
//  AppDelegate.swift
//  Todo
//
//  Created by Jenny Woorim Lee on 2021/01/29.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
             let _ = try Realm()
        } catch {
            print("Error initializing Realm \(error)" )
        }
        return true
        
    }
    
    

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

   
