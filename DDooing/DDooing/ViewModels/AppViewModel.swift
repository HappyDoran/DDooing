//
//  AppViewModel.swift
//  DDooing
//
//  Created by Doran on 5/19/24.
//

import Foundation
import SwiftUI
import Firebase

class AppViewModel: ObservableObject {
    @Published var currentView: AnyView?
    
    init() {
        self.checkAuthStatus()
    }
    
    //사용자인지 아닌지 체크
    func checkAuthStatus() {
        Auth.auth().addStateDidChangeListener { auth, user in //사용자의 상태가 로그인이 된 상태인지 아닌지 체크
            if let user = user {
                self.checkUserConnectionStatus(uid: user.uid)
            } else {
                DispatchQueue.main.async {
                    self.currentView = AnyView(LoginView())
                }
            }
        }
    }
    
    //사용자면 isConnected를 판단하여 RandomCodeView를 띄울지 LoginView를 띄울지 체크
    func checkUserConnectionStatus(uid: String) {
        let docRef = Firestore.firestore().collection("Users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let isConnected = document.get("isConnected") as? Bool ?? false
                DispatchQueue.main.async {
                    if isConnected {
                        self.currentView = AnyView(PartnerNameView())
                    } else {
                        self.currentView = AnyView(RandomCodeView())
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.currentView = AnyView(LoginView())
                }
            }
        }
    }
}
