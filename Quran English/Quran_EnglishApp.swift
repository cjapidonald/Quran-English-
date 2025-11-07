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
            print("❌ MODELCONTAINER ERROR: \(error)")
            print("❌ ERROR DETAILS: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("❌ ERROR CODE: \(nsError.code)")
                print("❌ ERROR DOMAIN: \(nsError.domain)")
                print("❌ ERROR USERINFO: \(nsError.userInfo)")
            }
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
