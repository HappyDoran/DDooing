//
//  AppModelContainer.swift
//  DDooing
//
//  Created by Doran on 5/23/24.
//

import Foundation
import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        MessageModel.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

