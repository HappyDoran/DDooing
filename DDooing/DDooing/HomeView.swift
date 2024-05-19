//
//  HomeView.swift
//  button
//
//  Created by 박하연 on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    // 데이터 가져오기 전 임시로 만든 변수들입니다.
    let name = "하연이"
    var tem_messages = ["뭐해?" , "오늘 특히 더 보고싶다" , "상아 보고싶어서 뚜잉 뚜잉 중~", "오늘 뭐먹지?", "메롱", "ㅋㅋ"]
    @State private var randomMessages : String
    @State private var showingAlert = false
    @State private var showContextMenu = false
    
    init() {
        _randomMessages = State(initialValue: tem_messages.randomElement()!)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                randomMessages = tem_messages.randomElement()!
                    showingAlert = true
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
        .padding()
    }
}

func selectingRandomly() {
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
}
