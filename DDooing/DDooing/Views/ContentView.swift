//
//  FirstView.swift
//  DDooing
//
//  Created by Doran on 5/19/24.
//

import SwiftUI
import Firebase
import AppIntents
import WidgetKit

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        Group {
            //체크하는 중에는 로딩 뷰를 띄움
            if let currentView = viewModel.currentView {
                currentView
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}

class MessagingService {
    static var partnerUID: String = ""
    static var currentUserUID: String = ""
    static var randomMessages: String = ""
    static var partnerDeviceToken: String = ""
    static var partnerName: String = ""
    
    static func sendMessage() {
        let db = Firestore.firestore()
        print("db init")
        
        print(currentUserUID)
        
        
        let currentUserRef = db.collection("Received-Messages")
            .document(currentUserUID).collection(partnerUID).document()
        
        let partnerRef = db.collection("Received-Messages")
            .document(partnerUID).collection(currentUserUID)
        
        let recentPartnerRef = db.collection("Received-Messages")
            .document(partnerUID).collection("recent-messages")
            .document(currentUserUID)
        
        let messageId = currentUserRef.documentID
        
        let messageData: [String: Any] = [
            "fromId": currentUserUID,
            "toId": partnerUID,
            "messageText": randomMessages,
            "timeStamp": Timestamp(date: Date()),
            "isStarred": false,
            "messageId": messageId
        ]
        
        // 메시지 데이터를 Firestore에 저장
        partnerRef.document(messageId).setData(messageData)
        recentPartnerRef.setData(messageData)
    }
    
    static func fetchAccessTokenAndSendPushNotification(){
        // 서버로부터 OAuth 2.0 액세스 토큰 가져오기
        //여기부분은 깃에 올릴 때 삭제하고 올리시기 바랍니다.
        guard let url = URL(string: "") else {
            print("Invalid URL for token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            // 서버로부터 받은 응답을 문자열로 변환하여 출력
            if let accessToken = String(data: data, encoding: .utf8) {
                print("Access Token String: \(accessToken)")
                sendPushNotification(with: accessToken)
            } else {
                print("Invalid token response")
            }
        }.resume()
    }
    
    static func sendPushNotification(with accessToken: String)  {
        guard !accessToken.isEmpty else {
            print("Access token is empty")
            return
        }
        
        // HTTP v1 API의 엔드포인트 URL
        guard let url = URL(string: "https://fcm.googleapis.com/v1/projects/ddooing-8881b/messages:send") else {
            print("Invalid URL for FCM")
            return
        }
        print("partnerdevicetoken >>> \(partnerDeviceToken)")
        print("pushMessage >>> \(randomMessages)")
        print("parname >>> \(partnerName)")
        let json: [String: Any] = [
            "message": [
                "token": partnerDeviceToken,
                "notification": [
                    "body": randomMessages,
                    "title": partnerName
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, err in
                if let err = err {
                    print("Error sending push notification: \(err.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                print("Push notification response status code: \(httpResponse.statusCode)")
            
            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("Response Body: \(responseBody)")
                    }
                
                if httpResponse.statusCode == 200 {
                    print("Push notification sent successfully")
                } else {
                    print("Failed to send push notification")
                }
        }.resume()
    }
}

// Intent에서 사용
struct SendMessageIntent: AppIntent {
    
    static var title: LocalizedStringResource = .init(stringLiteral: "DDooing Send Message")
    
    @Parameter(title : "Random Message")
    var randomMessage : String
    
    @Parameter(title : "PartnerUID")
    var partnerUID : String
    
    @Parameter(title : "CurrentUserUID")
    var currentUserUID : String
    
    @Parameter(title : "PartnerDeviceToken")
    var partnerDeviceToken : String
    
    @Parameter(title : "PartnerName")
    var partnerName : String
    
    
    init(randomMessage: String, partnerUID: String, currentUserUID: String, partnerDeviceToken: String, partnerName: String) {
        self.randomMessage = randomMessage
        self.partnerUID = partnerUID
        self.currentUserUID = currentUserUID
        self.partnerDeviceToken = partnerDeviceToken
        self.partnerName = partnerName
    }
    
    init() {
        //empty
    }
    
    func perform() async throws -> some IntentResult {
        print("앱이 꺼져있어도 실행이 됩니다.")
        
        // 랜덤 메시지 설정
        MessagingService.randomMessages = randomMessage
        MessagingService.partnerUID = partnerUID
        MessagingService.currentUserUID = currentUserUID
        // 메시지 보내기
        MessagingService.sendMessage()
        
        //푸시알림 설정
        MessagingService.partnerDeviceToken = partnerDeviceToken
        MessagingService.partnerName = partnerName
        
        //푸시알림 보내기
        MessagingService.fetchAccessTokenAndSendPushNotification()
        
        
        return .result()
    }
}
