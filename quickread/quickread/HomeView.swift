//
//  HomeView.swift
//  quickread
//
//  Created by Li Qiu on 5/26/23.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ForYouView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("For You")
                }
                .tag(0)
            
            LibraryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Library")
                }
                .tag(1)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
