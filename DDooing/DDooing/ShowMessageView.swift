//
//  ShowMessageView.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    var isStarred: Bool = false
}

struct ShowMessageView: View {
    
    @State private var messages = [
        Message(text: "많이 보고싶어😘"),
        Message(text: "주말에 놀러갈까?"),
        Message(text: "오늘도 화이팅💪"),
        Message(text: "메롱"),
        Message(text: "오늘 네 생각이 더 많이 나더라 특히"),
        Message(text: "오늘도 럭키비키 걸🍀"),
        Message(text: "상아 생각나서 버튼 뚜잉 뚜잉 중~")
    ]
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Image("Letter")
                    .resizable()
                    .frame(width: 85, height: 100)
                    .padding()
                
                List {
                    ForEach($messages) { $message in
                        HStack {
                            Text(message.text)
                            Spacer()
                            if message.isStarred {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let index = messages.firstIndex(where: { $0.id == message.id }) {
                                    messages.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                message.isStarred.toggle()
                                sortMessages()
                            } label: {
                                Label("Star", systemImage: "star.fill")
                            }
                            .tint(.orange)
                        }
                    }
                }
                .listStyle(.inset)
            }
            .navigationTitle("메세지 문구")
            .toolbar {
                Button {
                    // 새로운 메세지 문구 추가 action
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func sortMessages() {
        messages.sort { $0.isStarred && !$1.isStarred }
    }
}


#Preview {
    ShowMessageView()
}
