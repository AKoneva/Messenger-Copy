//
//  Messenger_CopyApp.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

@main
struct Messenger_CopyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // This method is called when the app enters the background.
        // Set the user's online status to offline.
        if let currentUser = Auth.auth().currentUser {
            UserService.shared.setUserOnlineStatus(uid: currentUser.uid, isOnline: false)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // This method is called when the app is about to terminate.
        // Set the user's online status to offline.
        if let currentUser = Auth.auth().currentUser {
            UserService.shared.setUserOnlineStatus(uid: currentUser.uid, isOnline: false)
        }
    }
}
