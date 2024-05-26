//
//  NotificationData.swift
//  DDooing
//
//  Created by kimjihee on 5/25/24.
//

import SwiftData
import SwiftUI

@Model
final class NotificationDataModel {
    @Attribute(.unique) var id: UUID
    var body: String
    var title: String
    
    init(body: String, title: String) {
        self.id = UUID()
        self.body = body
        self.title = title
    }
}
