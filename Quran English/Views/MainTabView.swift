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
                    Label("Surahs", systemImage: "book.fill")
                }
                .tag(0)

            StudyView()
                .tabItem {
                    Label("Study", systemImage: "note.text.badge.plus")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(AppColors.cardBackground)

            // Selected item color
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.neonCyan)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColors.neonCyan)]

            // Unselected item color
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppColors.secondaryText)]

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}
