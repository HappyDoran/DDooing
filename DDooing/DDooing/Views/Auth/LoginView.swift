//
//  LoginView.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//

import SwiftUI
import Firebase
import AuthenticationServices

struct LoginView: View {
    @StateObject private var loginData = LoginViewModel()
    @State var isLoginMode = false
    @State var isAuthenticated = false
    @Environment(\.colorScheme) var colorScheme //현재 색상 모드 가져오기
    
    var body: some View {
        NavigationStack{
            VStack(spacing:0){
//                Text("DDooing").font(.pretendardBold40)
//                    .padding(.bottom,120)
                Image(colorScheme == .dark ? "Title-dark" : "Title-white") // 색상 모드에 따라 이미지 변경
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 170)
                    .padding(.bottom, 55)
                
                Image("Heart button")
                    .resizable()
                    .frame(width: 190,height: 170)
                    .padding(.bottom,150)
                
                SignInWithAppleButton { (request) in
                    loginData.nonce = randomNonceString()
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = sha256(loginData.nonce)
                    
                } onCompletion: { (result) in
                    switch result {
                    case .success(let user):
                        print("success")
                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                            print("error with firebase")
                            return
                        }
                        loginData.authenticate(credential: credential)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black) // 색상 모드에 따라 버튼 스타일 변경
                .frame(width: 345, height: 54)
            }
            .padding(.horizontal, 16)
            .padding(.top,100)
            Spacer()
            
            NavigationLink(
                destination: RandomCodeView(),
                isActive: $loginData.isAuthenticated, //여기서 사용자 로그인이 잘 됐으면 화면 전환
                label: {
                    EmptyView()
                })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().preferredColorScheme(.dark)
    }
}
