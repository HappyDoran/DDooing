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
    @Query private var messages: [MessageModel]
    @State private var newMessage = ""
    @State private var showAlert = false
    @State private var showAlert2 = false
    
    var body: some View {
        
        NavigationStack {
                List {
//                    Text("메세지 문구")
//                        .font(.largeTitle)
//                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                        .listRowSeparator(.hidden)
                    // 편지 사진
                    HStack{
                        Spacer()
                        Image("post1")
                            .resizable()
                            .frame(width: 130, height: 120)
                            .scaledToFill()
                            
                        
                        Spacer()
                    }.listRowSeparator(.hidden)
                    
                    Section(header:  Button(action: {addItem()}, label: {
                        HStack{
                            Spacer()
                            Image(systemName: "plus")
                                .listRowSeparator(.hidden)
                            }
                        .background()
                    })) {
                        ForEach(messages.sorted(by: { $0.createdDate > $1.createdDate })) { mess in
                            if mess.isStarred {
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
                        
                        
                        ForEach(messages.sorted(by: { $0.createdDate > $1.createdDate })) { mess in
                            if mess.isStarred == false {
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
                                    toggleStar(mess: mess)
                                } label: {
                                    Label("Star", systemImage: "star.fill")
                                }
                               
                                .tint(.orange)
                            }
                            }
                            
                            
                            
                        }
                        
                    }   
                    
                }
                
                .listStyle(.plain)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("DDooing"),
                        message: Text("즐겨찾기는 최대 3개까지 가능합니다."),
                        dismissButton: .default(Text("확인"))
                    )
                }
                .alert(isPresented: $showAlert2) {
                    Alert(
                        title: Text("DDooing"),
                        message: Text("이미 추가됌"),
                        dismissButton: .default(Text("확인"))
                    )
                }
                .navigationTitle("메세지 문구")
        }
    }
    
//    func sortMessages() {
//        messages.sort { $0.isStarred && !$1.isStarred }
//    }
    func addItem() {
                let emptyMessagesCount = messages.filter { $0.message == "" }.count
        if emptyMessagesCount == 0  {
            // 새로운 Item을 생성하고 modelContext에 추가합니다.
            let newItem = MessageModel(message: newMessage, isStarred: false , createdDate: Date())
            modelContext.insert(newItem)
        } else {
            showAlert2 = true
        }
        }
    func saveContext() {
            // SwiftData 모델 컨텍스트 저장
            do {
                try modelContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    func deleteItem(item: MessageModel) {
        // modelContext에서 아이템 삭제
        modelContext.delete(item)
        saveContext()
    }
    
    func toggleStar(mess: MessageModel) {
            let starredMessagesCount = messages.filter { $0.isStarred }.count
            if mess.isStarred || starredMessagesCount < 3 {
                mess.isStarred.toggle()
                saveContext()
            } else {
                print("즐겨찾기는 최대 3개까지 가능합니다.")
                showAlert = true
            }
        }


    
}




#Preview {
    TextEditView()
        .modelContainer(for: MessageModel.self,  inMemory: true)
}
