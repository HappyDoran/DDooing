//
//  DDooingWidgetBundle.swift
//  DDooingWidget
//
//  Created by Doran on 5/22/24.
//

import WidgetKit
import SwiftUI

@main
struct DDooingWidgetBundle: WidgetBundle {
    var body: some Widget {
        DDooingWidget()
        DDooingWidgetLiveActivity()
    }
}
