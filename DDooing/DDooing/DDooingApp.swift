//
//  DDooingApp.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//

import SwiftUI
import Firebase

@main
struct DDooingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if (Auth.auth().currentUser?.reload()) != nil {
                RandomCodeView()
            } else {
                LoginView()
            }
        }
        .modelContainer(for: [Message.self])
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    @Published var isLoggedin: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Firebase 인증 상태 감지
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                //로그인 상태
                print("User is signed in with UID:", user.uid)
                
            } else {
                //로그아웃 상태
                print("User is not signed in.")
            }
        }
        
        return true
    }
}
