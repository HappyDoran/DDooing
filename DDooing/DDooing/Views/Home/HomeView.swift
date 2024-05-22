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
    @GestureState private var isPressed = false
    @State private var isLongPressed = false
    
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
//                Button(action: {
//                    if let randomMessage = messages.randomElement() {
//                        randomMessages = randomMessage.message
//                    }
//                    saveRandomMessage()
//                    print("메시지 입력")
//                }, label: {
//                    Image("Heart button")
//                        .resizable()
//                        .frame(width: 230,height: 200)
//                })
//                .onLongPressGesture {
//                    showContextMenu = true
//                }
//                .contextMenu(menuItems: {
//                    ForEach(messages) { mess in
//                        if mess.isStarred {
//                            Button (action: {}, label: {
//                                Text(mess.message)
//                            })
//                        }}
//                })
//                .padding(.bottom, 30)
//                Text("\(postPositionText(name)) 생각하며 눌러보세요.")
//                    .font(.headline)
//
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
                    .scaleEffect(isPressed ? 0.8 : 0.7) // 작아지는 효과
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
                                Button (action: {}, label: {
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
                                        randomMessages = randomMessage.message
                                    }
                                    saveRandomMessage()
                                    print("메시지 입력")
                                }
                                isLongPressed = false
                            }
                    )
                Text("\(postPositionText(name)) 생각하며 눌러보세요.")
                    .font(.headline)
                    .padding(.bottom,130)


                
                
                
                Spacer()
                

            }
            .padding()
//            .navigationTitle("DDooing")
        }
    }
    
    func saveRandomMessage() {
        guard let partnerUID = partnerUID else { return }
        sendMessage(messageText: randomMessages, isStarred: false)
    }
    
    func sendMessage(messageText: String, isStarred: Bool) {
        let db = Firestore.firestore()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let currentUserRef = db.collection("Received-Messages")
            .document(partnerUID).collection(currentUid).document()
        
        let recentCurrentUserRef = db.collection("Received-Messages")
            .document(partnerUID).collection("recent-messages")
            .document(currentUid)
        
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
        recentCurrentUserRef.setData(messageData)
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

