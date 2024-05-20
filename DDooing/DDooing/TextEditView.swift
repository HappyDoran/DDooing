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


struct TextEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var messages: [Message]
    @State private var newMessage = ""
    
    var body: some View {
        
        NavigationStack {
           
                List {
                    Text("메세지 문구")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .listRowSeparator(.hidden)
                    // 편지 사진
                    HStack{
                        Spacer()
                        Image("Letter")
                            .resizable()
                            .frame(width: 85, height: 100)
                        
                        Spacer()
                            
                    }.listRowSeparator(.hidden)
                    
                    
                    Section(header:  Button(action: {addItem()}, label: {
                        HStack{
                            Spacer()
                            Image(systemName: "plus")
                                .listRowSeparator(.hidden)
                                .foregroundColor(.blue)
                            }
                        .background()
                    })) {
                       
                        ForEach(messages) { mess in
                            HStack {
                                TextField("문구를 입력해주세요", text: Binding(
                                    get: { mess.message },
                                    set: { mess.message = $0 }
                                )).onChange(of: mess.message,  initial: true) {
                                    saveContext()
                                }
                                Spacer()
                                if mess.isStarred {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                }
                            }.swipeActions {
                                
                                
                                Button(role: .destructive) {
                                    deleteItem(item: mess)
                                  } label: {
                                   Label("Delete", systemImage: "trash")
                                  }
                                
                                
                                Button {
                                    mess.isStarred.toggle()
                                } label: {
                                    Label("Star", systemImage: "star.fill")
                                }
                                .tint(.orange)
                            }
                        }
                        
                    }
                        
                        
                    
                }
                .listStyle(.plain)

        }
        .navigationTitle("메세지 문구")
    }
    
//    func sortMessages() {
//        messages.sort { $0.isStarred && !$1.isStarred }
//    }
    func addItem() {
                // 새로운 Item을 생성하고 modelContext에 추가합니다.
                let newItem = Message(message: newMessage, isStarred: false )
                modelContext.insert(newItem)
        }
    func saveContext() {
            // SwiftData 모델 컨텍스트 저장
            do {
                try modelContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    func deleteItem(item: Message) {
        // modelContext에서 아이템 삭제
        modelContext.delete(item)
        saveContext()
    }

    
}




#Preview {
    TextEditView()
        .modelContainer(for: Message.self,  inMemory: true)
}
