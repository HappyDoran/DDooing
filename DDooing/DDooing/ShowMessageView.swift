
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
}

struct ShowMessageView: View {
    
    @State private var recivedMessages = [
        RecivedMessage(name: "현집", text: "많이 보고싶어", time: Date()),
        RecivedMessage(name: "현집", text: "오늘도 화이팅", time: Date()),
        RecivedMessage(name: "현집", text: "럭키비키 걸~", time: Date()),
        RecivedMessage(name: "현집", text: "메롱", time: Date()),
        RecivedMessage(name: "현집", text: "많이 보고싶어", time: Date()),
        RecivedMessage(name: "현집", text: "많이 보고싶어", time: Date())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image("Mailbox")
                    .resizable()
                    .frame(width: 110, height: 85)
                    .padding()
                ForEach(recivedMessages) { message in
                    HStack {
                        LazyVStack(alignment: .leading) {
                            HStack {
                                Image("SmallHeart")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(message.name)
                            }
                            .padding(.leading)
                            
                            Text(message.text)
                                .padding(.leading)
                        }
                        .frame(width: 300, height: 70)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.secondary))

                        
                        Spacer()
                        
                        VStack {
                            if message.isNewMessage {
                                HStack {
                                    Spacer()
                                    Image(systemName: "moonphase.new.moon")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.red)
                                }
                            }
                            Spacer()
                            Text(formattedTime(from: message.time))
                        }
                    }
                    .padding(.top, 5)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                }
            }
            // 새로운 메세지가 왔을 때 어떻게 보이는지 테스트용 버튼
            .toolbar {
                Button {
                    toggleNewMessages()
                } label: {
                    Text("NewMessage test")
                }
            }
            .navigationTitle("오늘의 메시지")
        }
    }
    
    // 새로운 메세지가 왔을 때 어떻게 보이는지 테스트용 함수
    func toggleNewMessages() {
        for index in recivedMessages.indices {
            recivedMessages[index].isNewMessage.toggle()
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
