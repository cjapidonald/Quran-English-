//
//  SampleQuranData.swift
//  Quran English
//
//  Lightweight placeholder data that keeps the UI functional while
//  the original Quran content is removed.
//

import Foundation

struct SampleQuranData {
    static func createSampleVerses() -> [QuranVerse] {
        var verses: [QuranVerse] = []

        let verse1Words = [
            QuranWord(arabic: "Sample", englishTranslation: "Sample", position: 0),
            QuranWord(arabic: "text", englishTranslation: "text", position: 1),
            QuranWord(arabic: "only", englishTranslation: "only", position: 2)
        ]
        let verse1 = QuranVerse(
            surahNumber: 1,
            verseNumber: 1,
            words: verse1Words,
            fullEnglishTranslation: "Placeholder translation used for testing the UI."
        )
        verses.append(verse1)

        let verse2Words = [
            QuranWord(arabic: "More", englishTranslation: "More", position: 0),
            QuranWord(arabic: "sample", englishTranslation: "sample", position: 1),
            QuranWord(arabic: "words", englishTranslation: "words", position: 2)
        ]
        let verse2 = QuranVerse(
            surahNumber: 1,
            verseNumber: 2,
            words: verse2Words,
            fullEnglishTranslation: "Add your own content source when it is ready."
        )
        verses.append(verse2)

        return verses
    }
}
