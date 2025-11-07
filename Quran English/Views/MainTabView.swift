//
//  MainTabView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            SurahsView()
                .tabItem {
                    Label("Surahs", systemImage: "book")
                }
                .tag(0)

            StudyView()
                .tabItem {
                    Label("Study", systemImage: "note.text")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainTabView()
}
