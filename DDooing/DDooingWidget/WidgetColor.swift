//
//  WidgetColor.swift
//  DDooing
//
//  Created by Doran on 5/22/24.
//

import Foundation
import SwiftUI

import SwiftUI
//원하는 컬러 생성
extension Color {
 
    static let widgetTopColor = Color(hex:"#FF9898")
    static let widgetBottomColor = Color(hex:"#FFCFCF")
    
    
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
