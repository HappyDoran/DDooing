//
//  HomeView.swift
//  button
//
//  Created by 박하연 on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    let name = "하연"
    @GestureState var longPress = false //하다 맘.. 이것만 썼음
    
    var body: some View {
        VStack {
            Button(action: {}, label: {
                Image("Heart button")
                    .resizable()
                    .frame(width: 190,height: 170)
            })
            .padding(.bottom, 30)
            Text("\(postPositionText(name)) 생각하며 눌러보세요.")
                .font(.headline)
                
        }
        .padding()
    }
}

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

#Preview {
    HomeView()
}
