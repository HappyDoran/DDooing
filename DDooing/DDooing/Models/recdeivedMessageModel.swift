//
//  recdeivedMessageModel.swift
//  DDooing
//
//  Created by kimjihee on 5/21/24.
//

import Foundation

struct RecievedMessage: Identifiable {
    let id: String
    var name: String
    let text: String
    var time: Date
    var isNew: Bool = false
    var isStarred: Bool = false
    
    init(id: String, name: String, text: String, time: Date, isNew: Bool = false, isStarred: Bool = false) {
        self.id = id
        self.name = name
        self.text = text
        self.time = time
        self.isNew = isNew
        self.isStarred = isStarred
    }
}
