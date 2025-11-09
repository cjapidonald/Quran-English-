//
//  QuranJSONParser.swift
//  Quran English
//
//  JSON parser for the English Rwwad translation
//

import Foundation

struct QuranJSONParser {

    struct VerseData: Codable {
        let id: Int
        let surah: Int
        let ayah: Int
        let translation: String
        let footnotes: String
        let arabic: String
    }

    /// Parses the JSON file and returns all verse data
    static func parseJSON(from filename: String) -> [VerseData] {
        NSLog("🔍 Looking for JSON file: \(filename).json")

        guard let filepath = Bundle.main.path(forResource: filename, ofType: "json") else {
            NSLog("❌ JSON file not found: \(filename).json")
            return []
        }

        NSLog("✅ Found JSON at: \(filepath)")

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)) else {
            NSLog("❌ Could not read JSON file")
            return []
        }

        NSLog("📖 JSON file size: \(data.count) bytes")

        let decoder = JSONDecoder()
        guard let verses = try? decoder.decode([VerseData].self, from: data) else {
            NSLog("❌ Could not decode JSON")
            return []
        }

        NSLog("✅ Parsed \(verses.count) verses from JSON")

        // Debug: Show first verse
        if let first = verses.first {
            NSLog("📖 First verse: Surah \(first.surah):\(first.ayah)")
            NSLog("🔤 Arabic: \(first.arabic.prefix(50))...")
            NSLog("🔤 English: \(first.translation.prefix(50))...")
        }

        return verses
    }
}
