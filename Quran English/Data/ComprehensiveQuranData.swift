//
//  ComprehensiveQuranData.swift
//  Quran English
//
//  Complete Quran data loader with English Rwwad translation
//  Source: https://quranenc.com/en/browse/english_rwwad
//

import Foundation

struct ComprehensiveQuranData {

    /// Returns all 114 Surahs loaded from the English Rwwad translation JSON
    static func createAllSurahs() -> [Surah] {
        NSLog("📚 createAllSurahs() called - starting data load")

        // Parse the JSON file
        let verseDataArray = QuranJSONParser.parseJSON(from: "english_rwwad")

        if verseDataArray.isEmpty {
            NSLog("⚠️ No verses loaded from JSON. Make sure english_rwwad.json is added to the Xcode project.")
            return []
        }

        NSLog("📊 Loaded \(verseDataArray.count) verses from JSON")

        // Group verses by Surah number
        var versesBySurah: [Int: [QuranJSONParser.VerseData]] = [:]
        for verseData in verseDataArray {
            if versesBySurah[verseData.surah] == nil {
                versesBySurah[verseData.surah] = []
            }
            versesBySurah[verseData.surah]?.append(verseData)
        }

        // Create Surah objects with metadata
        var surahs: [Surah] = []

        for metadata in SurahMetadata.allSurahs {
            let surah = Surah(
                surahNumber: metadata.number,
                name: metadata.name,
                arabicName: metadata.arabicName,
                revelationType: metadata.revelationType,
                numberOfVerses: metadata.numberOfVerses,
                verses: []
            )

            // Create verses for this Surah
            if let versesData = versesBySurah[metadata.number] {
                let verses = versesData.map { verseData in
                    // Debug: Log first verse of first surah
                    if metadata.number == 1 && verseData.ayah == 1 {
                        NSLog("🔤 First verse Arabic: \(verseData.arabic.prefix(50))...")
                        NSLog("🔤 First verse English: \(verseData.translation.prefix(50))...")
                    }

                    // Create verse with Arabic text stored directly
                    let verse = QuranVerse(
                        surahNumber: verseData.surah,
                        verseNumber: verseData.ayah,
                        words: [],
                        fullEnglishTranslation: verseData.translation,
                        fullArabicText: verseData.arabic,
                        surah: surah
                    )

                    // Create a word with the full Arabic text for word-by-word display
                    let arabicWord = QuranWord(
                        arabic: verseData.arabic,
                        englishTranslation: verseData.translation,
                        position: 0,
                        verse: verse
                    )

                    // Set the words array
                    verse.words = [arabicWord]

                    return verse
                }
                surah.verses = verses
            }

            surahs.append(surah)
        }

        NSLog("✅ Loaded \(surahs.count) Surahs with complete English Rwwad translation")
        NSLog("📚 createAllSurahs() completed successfully")
        return surahs
    }
}
