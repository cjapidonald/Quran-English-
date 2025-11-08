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
    init() {
        // Enable CloudKit debug logging for monitoring sync
        UserDefaults.standard.set(true, forKey: "com.apple.CoreData.CloudKitDebug")
        print("🔵 CloudKit Debug Logging Enabled")
        print("🔵 Container: iCloud.com.donald.kuranianglisht")
        print("🔵 Watching for sync activity...")
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            QuranVerse.self,
            QuranWord.self,
            Surah.self,
            QuranNote.self,
            NoteCategory.self,
            FavoriteVerse.self,
            ReadingProgress.self,
            MemorizedVerse.self,
            VerseViewProgress.self,
        ])

        // OPTION 1: Local-only storage (no CloudKit sync)
        // let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        // OPTION 2: Enable CloudKit sync - CURRENTLY ACTIVE
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .private("iCloud.com.donald.kuranianglisht")
        )

        // OPTION 3: Separate configs for shared and private data (recommended)
        // See CloudKit-Schema.md for full setup instructions

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

            // If CloudKit fails, fall back to local-only storage
            print("⚠️ CloudKit ModelContainer failed. Trying local-only storage...")
            do {
                let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                fatalError("Could not create ModelContainer even with fallback: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
