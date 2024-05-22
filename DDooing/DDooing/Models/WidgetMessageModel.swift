//
//  WidgetMessageModel.swift
//  DDooing
//
//  Created by Doran on 5/22/24.
//

import Foundation
import AppIntents
import WidgetKit

class WidgetMessageModel{
    private static let sharedDefaults: UserDefaults = UserDefaults(suiteName: "group.com.Seodongwon.DDooing")!
    
    static func saveMessage() {
        print("버튼 클릭")
    }
}

struct SendMessageIntent : AppIntent {
    static var title : LocalizedStringResource = "send message"
    static var description =  IntentDescription("Send random message with the main app.")
    
    
    @Parameter(title: "Partner UID")
    var partnerUID : String
    
    func perform() async throws -> some IntentResult {
        WidgetMessageModel.saveMessage()
        return .result()
    }
    
}
