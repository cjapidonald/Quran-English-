//
//  SampleSurahData.swift
//  Quran English
//
//  Placeholder chapter data for development after removing the Quran text.
//

import Foundation

struct SampleSurahData {
    static func createSampleSurahs() -> [Surah] {
        let placeholderVerses = SampleQuranData.createSampleVerses()
        let sampleSurah = Surah(
            surahNumber: 1,
            name: "Sample Chapter",
            arabicName: "Placeholder",
            revelationType: "Demo",
            numberOfVerses: placeholderVerses.count,
            verses: placeholderVerses
        )

        return [sampleSurah]
    }
}
