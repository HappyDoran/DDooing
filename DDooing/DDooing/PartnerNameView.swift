//
//  PartnerNameView.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PartnerNameView: View {
    @StateObject private var viewModel = UserStatusViewModel()
    @State private var isConnectionMode = true
    @State private var nickname = ""
    @State private var randomCode = ""
    
    var body: some View {
        
        NavigationStack{
            VStack(spacing:0){
                Text("DDooing").font(.pretendardBold40)
                    .padding(.bottom, 30)
                
                Text("파트너의 별명을 입력해주세요.").font(.pretendardBold18)
                    .padding(.bottom, 70)

                TextField("Nickname", text: $nickname)
                    .keyboardType(.namePhonePad).autocapitalization(.none)
                    .font(.pretendardBold32)
                    .padding(.leading, 32)
                    .padding(.trailing, 32)
                Rectangle()
                    .frame(height: 1)
                //                    .foregroundColor(.white)
                    .padding(.leading, 32)
                    .padding(.trailing, 32)
                    .padding(.bottom, 73)
                
                Button(action: {
                    if let user = Auth.auth().currentUser {
                        setUsersNickname(nick: nickname, userAUID: user.uid)
                    }
                }, label: {
                    Text("완료")
                        .font(.pretendardBold18)
                    //                        .foregroundStyle(.white)
                })
                .padding(.bottom,100)
            
                
                Text("추후 별명을 수정할 수 없습니다.")
            }
            .padding(.horizontal, 16)
            .padding(.top, 165)
            Spacer()
        }
        .padding(.horizontal,16)

        .navigationBarBackButtonHidden(true)
    }
}

func setUsersNickname(nick nickname : String, userAUID: String) {
    let db = Firestore.firestore()
    let docRef = db.collection("Users").document(userAUID)

    db.collection("Users").document(userAUID).updateData([
        "ConnectedNickname": nickname
    ]) { err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("상대방의 닉네임이 \(nickname)으로 정해졌습니다.")
        }
    }
}

struct PartnerNameView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerNameView().preferredColorScheme(.dark)
    }
}
