//
//  Model.swift
//  DDooing
//
//  Created by 문재윤 on 5/16/24.
//

import SwiftData
import SwiftUI

@Model
class MessageModel {
    var message: String
    var isStarred: Bool
    var createdDate: Date
    
    init(message: String, isStarred: Bool, createdDate: Date) {
        self.message = message
        self.isStarred = isStarred
        self.createdDate = createdDate
    }
}

