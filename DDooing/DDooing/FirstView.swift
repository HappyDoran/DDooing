//
//  FirstView.swift
//  DDooing
//
//  Created by Doran on 5/19/24.
//

import SwiftUI

struct FirstView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        Group {
            
            //체크하는 중에는 로딩 뷰를 띄움
            if let currentView = viewModel.currentView {
                currentView
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    FirstView()
}
