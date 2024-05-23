//
//  DDooingWidgetLiveActivity.swift
//  DDooingWidget
//
//  Created by Doran on 5/22/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DDooingWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DDooingWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DDooingWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DDooingWidgetAttributes {
    fileprivate static var preview: DDooingWidgetAttributes {
        DDooingWidgetAttributes(name: "World")
    }
}

extension DDooingWidgetAttributes.ContentState {
    fileprivate static var smiley: DDooingWidgetAttributes.ContentState {
        DDooingWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DDooingWidgetAttributes.ContentState {
         DDooingWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DDooingWidgetAttributes.preview) {
   DDooingWidgetLiveActivity()
} contentStates: {
    DDooingWidgetAttributes.ContentState.smiley
    DDooingWidgetAttributes.ContentState.starEyes
}
