//
//  TextEditView.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//
//
//  ShowMessageView.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//

import SwiftUI
import SwiftData

//struct Message: Identifiable {
//    let id = UUID()
//    let text: String
//    var isStarred: Bool = false
//}

struct TextEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var messages: [Message]
    @State private var newMessage = ""
//    @State private var messages = [
//        Message(text: "많이 보고싶어😘"),
//        Message(text: "주말에 놀러갈까?"),
//        Message(text: "오늘도 화이팅💪"),
//        Message(text: "메롱"),
//        Message(text: "오늘 네 생각이 더 많이 나더라 특히"),
//        Message(text: "오늘도 럭키비키 걸🍀"),
//        Message(text: "상아 생각나서 버튼 뚜잉 뚜잉 중~")
//    ]
    
    var body: some View {
        
        NavigationStack {
                List {
                    Section{
                        Image("Letter")
                            .resizable()
                            .frame(width: 85, height: 100)
                            .padding()
                            
                    }
                    Button(action: {addItem()}, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    })
                    ForEach(messages) { mess in
                        HStack {
                            TextField("", text: Binding(
                                get: { mess.message },
                                set: { mess.message = $0 }
                            ))
                            Spacer()
                            if mess.isStarred {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                        }
//                        .swipeActions {
//                            Button(role: .destructive) {
//                                if let index = messages.firstIndex(where: { $0.id == mess.id }) {
//                                    messages.remove(at: index)
//                                }
//                            } label: {
//                                Label("Delete", systemImage: "trash")
//                            }
//                            Button {
//                                mess.isStarred.toggle()
//                                sortMessages()
//                            } label: {
//                                Label("Star", systemImage: "star.fill")
//                            }
//                            .tint(.orange)
//                        }
                    }
                }
                .listStyle(.inset)

        }
//        .navigationTitle("메세지 문구")
    }
    
//    func sortMessages() {
//        messages.sort { $0.isStarred && !$1.isStarred }
//    }
    func addItem() {
                // 새로운 Item을 생성하고 modelContext에 추가합니다.
                let newItem = Message(message: newMessage, isStarred: false )
                modelContext.insert(newItem)
        }
}




#Preview {
    TextEditView()
        .modelContainer(for: Message.self,  inMemory: true)
}
