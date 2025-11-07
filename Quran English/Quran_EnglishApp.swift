//
//  Quran_EnglishApp.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

@main
struct Quran_EnglishApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            QuranVerse.self,
            QuranWord.self,
            Surah.self,
            QuranNote.self,
            NoteCategory.self,
            FavoriteVerse.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
