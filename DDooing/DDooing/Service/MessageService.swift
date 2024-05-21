//
//  MessageService.swift
//  DDooing
//
//  Created by kimjihee on 5/20/24.
//

import Firebase
import Foundation

struct MessageService {
    let partnerUid: String
    
    func sendMessage(messageText: String, isStarred: Bool) {
        let db = Firestore.firestore()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let currenrUserRef = db.collection("Received-Messages")
            .document(currentUid).collection(partnerUid).document()
        
        let PartnerRef = db.collection("Received-Messages")
            .document(partnerUid).collection(currentUid)
        
        let recentCurrentUserRef = db.collection("Received-Messages")
            .document(currentUid).collection("recent-messages")
            .document(partnerUid)
        
        let recentPartnerRef = db.collection("Received-Messages")
            .document(partnerUid).collection("recent-messages")
            .document(currentUid)
        
        let messageId = currenrUserRef.documentID
        
        let messageData: [String: Any] = [
            "fromId": currentUid,
            "toId": partnerUid,
            "messageText": messageText,
            "timeStamp": Timestamp(date: Date()),
            "isStarred": isStarred
        ]
        
        currenrUserRef.setData(messageData)
        PartnerRef.document(messageId).setData(messageData)
        recentCurrentUserRef.setData(messageData)
        recentPartnerRef.setData(messageData)
    }
    
    func observeMessages(completion: @escaping ([String: Any]) -> Void) {
        let db = Firestore.firestore()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = db.collection("Received-Messages")
            .document(currentUid)
            .collection(partnerUid)
            .order(by: "timeStamp", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
            }) else { return }
            
            let messages = changes.map { $0.document.data() }
            
            for message in messages {
                completion(message)
            }
        }
    }
}
