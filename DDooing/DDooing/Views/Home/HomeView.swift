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
    let name = "하연이"
    @Environment(\.modelContext) private var modelContext
    @Query private var messages: [MessageModel]
    @State private var randomMessages : String = ""
    @State private var showContextMenu = false
    let partnerUID: String!
    
    init(partnerUID: String?) {
        self.partnerUID = partnerUID
        if messages.randomElement() != nil {
            _randomMessages = State(initialValue: randomMessages)
        } else {
            _randomMessages = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                Button(action: {
                    if let randomMessage = messages.randomElement() {
                        randomMessages = randomMessage.message
                    }
                    saveRandomMessage()
                    print("메시지 입력")
                }, label: {
                    Image("Heart button")
                        .resizable()
                        .frame(width: 230,height: 200)
                })
                .onLongPressGesture {
                    showContextMenu = true
                }
                .contextMenu(menuItems: {
                    Button("ㅎㅎ") {}
                    Button("메롱") {}
                    Button("테스트지롱") {}
                })
                .padding(.bottom, 30)
                Text("\(postPositionText(name)) 생각하며 눌러보세요.")
                    .font(.headline)
                
                Text("[test] \(randomMessages)") // 나중에 없앨거에요. 확인용!
            }
            .padding()
            .navigationTitle("DDooing")
        }
    }
    
    func saveRandomMessage() {
        guard let partnerUID = partnerUID else { return }
        sendMessage(messageText: randomMessages, isStarred: false)
    }
    
    func sendMessage(messageText: String, isStarred: Bool) {
        let db = Firestore.firestore()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let currenrUserRef = db.collection("Received-Messages")
            .document(currentUid).collection(partnerUID).document()
        
        let PartnerRef = db.collection("Received-Messages")
            .document(partnerUID).collection(currentUid)
        
//        let recentCurrentUserRef = db.collection("Received-Messages")
//            .document(currentUid).collection("recent-messages")
//            .document(partnerUID)
        
        let recentPartnerRef = db.collection("Received-Messages")
            .document(partnerUID).collection("recent-messages")
            .document(currentUid)
        
        let messageId = currenrUserRef.documentID
        
        let messageData: [String: Any] = [
            "fromId": currentUid,
            "toId": partnerUID!,
            "messageText": messageText,
            "timeStamp": Timestamp(date: Date()),
            "isStarred": isStarred,
            "messageId": messageId
        ]
        
//        currenrUserRef.setData(messageData)
        PartnerRef.document(messageId).setData(messageData)
//        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
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
