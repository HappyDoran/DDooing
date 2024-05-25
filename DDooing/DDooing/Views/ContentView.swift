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
    
    static func sendMessage(partnerUID : String, currentUserUID: String, messageText: String, isStarred: Bool) {
        let db = Firestore.firestore()
        print("db init")
        
//        let currentUid = "fXnIoNjeH9VbF8cFkMGRkjgv4GQ2" //여기가 문제
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
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
            "messageText": messageText,
            "timeStamp": Timestamp(date: Date()),
            "isStarred": isStarred,
            "messageId": messageId
        ]
        
        // 메시지 데이터를 Firestore에 저장
        partnerRef.document(messageId).setData(messageData)
        recentPartnerRef.setData(messageData)
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
    
    init(randomMessage: String, partnerUID: String, currentUserUID: String) {
        self.randomMessage = randomMessage
        self.partnerUID = partnerUID
        self.currentUserUID = currentUserUID
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
        MessagingService.sendMessage(partnerUID : MessagingService.partnerUID, currentUserUID: MessagingService.currentUserUID, messageText: MessagingService.randomMessages, isStarred: false)
        
//        print(MessagingService.randomMessages)
//        print(MessagingService.partnerUID)
        
        return .result()
    }
}
