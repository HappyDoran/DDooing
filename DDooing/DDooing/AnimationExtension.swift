//
//  AnimationExtension.swift
//  DDooing
//
//  Created by Doran on 5/19/24.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
