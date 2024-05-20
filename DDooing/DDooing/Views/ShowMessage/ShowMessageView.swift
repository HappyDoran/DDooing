
//  ShowingMessageView.swift
//  DDooing_test
//
//  Created by 조우현 on 5/16/24.
//

import SwiftUI

struct RecivedMessage: Identifiable {
    let id = UUID()
    var name: String
    let text: String
    var time: Date
    var isNewMessage: Bool = false
    // Message 구조체의 isStarred와는 다른거라서 따로 만듦
    var isStarredMessage: Bool = false
}

struct ShowMessageView: View {
    
    @State private var recivedMessages = [
        RecivedMessage(name: "현집", text: "많이 보고싶어🥲", time: Date()),
        RecivedMessage(name: "현집", text: "오늘도 화이팅", time: Date()),
        RecivedMessage(name: "현집", text: "럭키비키 걸~", time: Date()),
        RecivedMessage(name: "현집", text: "메롱", time: Date()),
        RecivedMessage(name: "현집", text: "많이 보고싶어", time: Date()),
        RecivedMessage(name: "현집", text: "많이 보고싶어", time: Date())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // 메세지 개수에 따른 이미지 변경
                // 새로운 우체통 이미지로 변경 예정
                Image(imageName(for: recivedMessages.count))
                    .resizable()
                    .frame(width: 140, height: 110)
                
                Spacer()
                
                ForEach(recivedMessages) { message in
                    HStack {
                        HStack {
                            if message.isStarredMessage {
                                // 새로운 별+하트 이미지로 변경 예정
                                Image("StarredHeart")
                                    .resizable()
                                    .frame(width: 35, height: 30)
                            } else {
                                Image("Heart button")
                                    .resizable()
                                    .frame(width: 35, height: 30)
                            }
                            
                            
                            LazyVStack(alignment: .leading) {
                                Text(message.name)
                                    .bold()
                                
                                Text(message.text)
                                    .frame(width: 200, height: 10, alignment: .leading)
                            }
                            .padding(.leading, 5)
                            
                        }
                        .padding(.leading)

                        Spacer()
                        
                        LazyVStack(alignment: .trailing) {
                            if message.isNewMessage {
                                HStack {
                                    Spacer()
                                    Image(systemName: "moonphase.new.moon")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.red)
                                }
                            } else {
                                Spacer()
                            }
                            Text(formattedTime(from: message.time))
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                    }
                    .padding(.top, 20)
                }
//                .padding(.trailing)
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        // 새로운 메세지가 왔을 때 어떻게 보이는지 테스트용 버튼
                        Button {
                            toggleNewMessages()
                        } label: {
                            Text("NewMessage test")
                        }
                        // 즐겨찾기 한 메세지가 왔을 때 어떻게 보이는지 테스트용 버튼
                        Button {
                            toggleStarredMessages()
                        } label: {
                            Text("StarredMessage test")
                        }
                    } label: {
                        Label("test", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationTitle("오늘의 메시지")
        }
    }
    
    // 메세지 개수에 따른 이미지 변경 함수
    func imageName(for messageCount: Int) -> String {
        switch messageCount {
        case 1...10:
            return "Mailbox"
        case 11...20:
            return "Mailbox2"
        case 21...30:
            return "Mailbox3"
        default:
            return "MailboxEmpty"
        }
    }
    
    // 새로운 메세지가 왔을 때 어떻게 보이는지 테스트용 함수
    func toggleNewMessages() {
        for index in recivedMessages.indices {
            recivedMessages[index].isNewMessage.toggle()
        }
    }
    
    // 즐겨찾기 한 메세지가 왔을 때 어떻게 보이는지 테스트용 함수
    func toggleStarredMessages() {
        for index in recivedMessages.indices {
            recivedMessages[index].isStarredMessage.toggle()
        }
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}


#Preview {
    ShowMessageView()
}
