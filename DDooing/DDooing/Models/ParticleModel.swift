//
//  ParticleModel.swift
//  DDooing
//
//  Created by kimjihee on 5/26/24.
//

import SwiftUI

struct ParticleModel: Identifiable {
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    
    // Reset's all properties
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
}
