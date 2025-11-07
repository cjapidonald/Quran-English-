//
//  MainTabView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SurahsView()
                .tabItem {
                    Label("Surahs", systemImage: "book")
                }

            StudyView()
                .tabItem {
                    Label("Study", systemImage: "note.text")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
