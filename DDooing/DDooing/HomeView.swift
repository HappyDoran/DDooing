//
//  HomeView.swift
//  button
//
//  Created by 박하연 on 5/15/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    let name = "하연이"
    @Environment(\.modelContext) private var modelContext
    @Query private var messages: [Message]
    @State private var randomMessages : String = ""
    @State private var showingAlert = false
    @State private var showContextMenu = false
    
    init() {
        if messages.randomElement() != nil {
            _randomMessages = State(initialValue: randomMessages)
        } else {
            _randomMessages = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    if let randomMessage = messages.randomElement() {
                        randomMessages = randomMessage.message
                    }
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
                .alert("랜덤메시지가 전송되었습니다.", isPresented: $showingAlert) {
                    Button("확인") {
                    }
                }
                .padding(.bottom, 30)
                Text("\(postPositionText(name)) 생각하며 눌러보세요.")
                    .font(.headline)
                
                Text("[test] \(randomMessages)") // 나중에 없앨거에요. 확인용!
            }
            .navigationTitle("DDooing")
            .padding()
            .navigationBarBackButtonHidden(true)
        }
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
    HomeView()
        .modelContainer(for: Message.self,  inMemory: true)
}
