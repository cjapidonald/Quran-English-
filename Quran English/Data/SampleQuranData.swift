//
//  SampleQuranData.swift
//  Quran English
//
//  Sample data loader that provides verses from the first Surah (Al-Fātihah)
//  for quick testing. Uses the complete Quran data source.
//

import Foundation

struct SampleQuranData {
    static func createSampleVerses() -> [QuranVerse] {
        // Load all Surahs from the comprehensive data
        let allSurahs = ComprehensiveQuranData.createAllSurahs()

        // Return verses from the first Surah (Al-Fātihah) as a sample
        if let firstSurah = allSurahs.first, let verses = firstSurah.verses {
            return verses
        }

        // Fallback to empty array if data loading fails
        print("⚠️ Could not load sample verses")
        return []
    }

    /// Returns all Surahs for navigation views
    static func createAllSurahs() -> [Surah] {
        return ComprehensiveQuranData.createAllSurahs()
    }
}
