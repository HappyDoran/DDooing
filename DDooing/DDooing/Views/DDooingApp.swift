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
    
    @StateObject var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}

// Initializing firebase and cloud messaging
class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        // Setting cloud messaging
        Messaging.messaging().delegate = self
        
        // Setting notifications
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
          // Do something with message data here.
          
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // In order to receive notifications you need implement these methods.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
////            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//          }
//        }
    }

    
}

// Cloud messaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase register action token:")

        // Store this token to firebase and retrieve when to send message to someone.
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        if let user = Auth.auth().currentUser {
            setUsersFCMToken(token: fcmToken!, userAUID: user.uid)
        }
      
        // Store token in firestore for sending notifications from server in future
        print(dataDict)
    }
    
    private func setUsersFCMToken(token : String, userAUID: String) {
        let db = Firestore.firestore()
        
        db.collection("Users").document(userAUID).updateData([
            "deviceToken": token
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("토큰 저장 성공 : \(token)")
            }
        }
    }
}

// User notifications (InApp Notifications)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

        // Haptics
        // UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // Do something with message data.
        print("User Info: \(userInfo)")
        if let aps = userInfo["aps"] as? [String: Any],
            let alert = aps["alert"] as? [String: String],
            let body = alert["body"],
            let title = alert["title"] {
            // body와 title 값을 추출했습니다.
            // 여기서 SwiftData를 사용하여 값을 저장합니다.
//               saveNotificationData(body: body, title: title)
            print("User alert: \(alert)")
            print("User body: \(body)")
            print("User title: \(title)")
        }

        completionHandler([[.banner, .badge, .sound]])
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("User Info: \(userInfo)")

      completionHandler()
    }
}
