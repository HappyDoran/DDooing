//
//  ContentView.swift
//  DDooing
//
//  Created by Doran on 5/14/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("DDooing")
                }
            TextEditView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("메세지 문구")
                }
            ShowMessageView()
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("수신함")
                }
        }
    }
}

#Preview {
    MainView()
}
