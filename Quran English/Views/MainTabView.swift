//
//  MainTabView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var preferences = UserPreferences.shared

    var body: some View {
        TabView {
            SurahsView()
                .tabItem {
                    Label("Surahs", systemImage: "book")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.pie.fill")
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
        .preferredColorScheme(preferences.isDarkMode ? .dark : .light)
    }
}
