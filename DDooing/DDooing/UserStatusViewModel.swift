//
//  UserStatusViewModel.swift
//  DDooing
//
//  Created by Doran on 5/18/24.
//

import Foundation
import Firebase

class UserStatusViewModel: ObservableObject {
    @Published var isConnected: Bool = false
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    func observeUserConnectionStatus(userId: String) {
       
        let docRef = db.collection("Users").document(userId)

        listenerRegistration = docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            DispatchQueue.main.async {
                self.isConnected = data["isConnected"] as? Bool ?? false
            }
        }
    }
    
    deinit {
        // 리스너 제거
        listenerRegistration?.remove()
    }
}
