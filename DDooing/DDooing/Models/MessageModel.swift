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
    
    init(message: String, isStarred: Bool) {
        self.message = message
        self.isStarred = isStarred
    }
}
