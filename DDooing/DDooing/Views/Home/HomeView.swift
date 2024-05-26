//
//  HomeView.swift
//  button
//
//  Created by 박하연 on 5/15/24.
//

import Firebase
import Foundation
import SwiftUI
import SwiftData

struct HomeView: View {
    @State var name: String = ""
    @State var partnerName: String = ""
    @Environment(\.modelContext) private var modelContext
    @Query private var messages: [MessageModel]
    @State private var pushMessage : String = ""
    @State private var showContextMenu = false
    let partnerUID: String!
    @GestureState private var isPressed = false
    @State private var isLongPressed = false
    @Query<NotificationDataModel> private var notificationDataList: [NotificationDataModel]
    @State var partnerDeviceToken = ""
    
    init(partnerUID: String?) {
        self.partnerUID = partnerUID
        if messages.randomElement() != nil {
            _pushMessage = State(initialValue: pushMessage)
        } else {
            _pushMessage = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Text("DDooing")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                .padding(.vertical)
                
                Spacer()
                
                Image("Heart button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing,10)
                    .scaleEffect(isPressed ? 1.0 : 0.8) // 작아지는 효과
                    .animation(.easeInOut(duration: 0.3), value: isPressed) // 애니메이션 추가
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .updating($isPressed) { currentState, gestureState, transaction in
                                gestureState = currentState
                            }
                            .onEnded { _ in
                                isLongPressed = true
                                print("길게누름")
                            }
                    )
                    .contextMenu(menuItems: {
                        ForEach(messages) { mess in
                            if mess.isStarred {
                                Button (action: {
                                    pushMessage = mess.message
                                    sendMessage(messageText: pushMessage, isStarred: true)
                                    fetchAccessTokenAndSendPushNotification()
                                }, label: {
                                    Text(mess.message)
                                })
                            }}
                    })
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { _ in
                                if !isLongPressed {
                                    print("짧게누름")
                                    if let randomMessage = messages.randomElement() {
                                        pushMessage = randomMessage.message
                                    }
                                    print("메시지 입력")
                                    sendMessage(messageText: pushMessage, isStarred: false)
                                    fetchAccessTokenAndSendPushNotification()
                                }
                                isLongPressed = false
                            }
                            .particleEffect(systemImage: "suit.heart.fill", font: .title2, status: status, activeTint: .pink, inActiveTint: .gray)
                    )
                Text("\(postPositionText(name)) 생각하며 눌러보세요.")
                    .font(.headline)
                    .padding(.bottom,60)
                Spacer()
            }
            .padding()
            .onAppear {
                fetchMyConnectedNickname { fetchedName in
                    name = fetchedName
                    
                }

            }
        }
    }
    func fetchPartnerDeviceToken(completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("Users").document(partnerUID).getDocument { document, error in
            if let document = document, document.exists {
                partnerDeviceToken = document.data()?["deviceToken"] as? String ?? "Unknown"
                completion(partnerDeviceToken)
            } else {
                completion("Unknown")
            }
        }
    }
    
    func fetchPartnerConnectedNickname(completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("Users").document(partnerUID).getDocument { document, error in
            if let document = document, document.exists {
                partnerName = document.data()?["ConnectedNickname"] as? String ?? "Unknown"
                completion(partnerName)
            } else {
                completion("Unknown")
            }
        }
    }
    private func fetchMyConnectedNickname(completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion("Unknown")
            return
        }
        
        db.collection("Users").document(currentUid).getDocument { document, error in
            if let document = document, document.exists {
                name = document.data()?["ConnectedNickname"] as? String ?? "Unknown"
                completion(name)
            } else {
                completion("Unknown")
            }
        }
    }
    
    func sendMessage(messageText: String, isStarred: Bool) {
        let db = Firestore.firestore()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let currentUserRef = db.collection("Received-Messages")
            .document(partnerUID).collection(currentUid).document()

        let messageId = currentUserRef.documentID
        
        let messageData: [String: Any] = [
            "fromId": partnerUID!,
            "toId": currentUid,
            "messageText": messageText,
            "timeStamp": Timestamp(date: Date()),
            "isStarred": isStarred,
            "messageId": messageId
        ]
        
        currentUserRef.setData(messageData)
    }
    
    func fetchAccessTokenAndSendPushNotification() {
        fetchPartnerDeviceToken { fetchedtoken in
            partnerDeviceToken = fetchedtoken
        }
        fetchPartnerConnectedNickname { fetchedName in
            partnerName = fetchedName
        }
        
        // 서버로부터 OAuth 2.0 액세스 토큰 가져오기
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
    
    func sendPushNotification(with accessToken: String)  {
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
        print("pushMessage >>> \(pushMessage)")
        print("parname >>> \(partnerName)")
        let json: [String: Any] = [
            "message": [
                "token": partnerDeviceToken,
                "notification": [
                    "body": pushMessage,
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

// 을,를 구분
func postPositionText(_ name: String) -> String {
    // 글자의 마지막 부분을 가져옴
    guard let lastText = name.last else { return name }
    // 유니코드 전환
    let unicodeVal = UnicodeScalar(String(lastText))?.value

    guard let value = unicodeVal else { return name }
    // 한글아니면 반환
    if (value < 0xAC00 || value > 0xD7A3) { return name }
    // 종성인지 확인
    let last = (value - 0xAC00) % 28
    // 받침있으면 을 없으면 를 반환
    let str = last > 0 ? "을" : "를"
    return name + str
}


// Preview
#Preview {
    HomeView(partnerUID: nil)
        .modelContainer(for: MessageModel.self,  inMemory: true)
}


