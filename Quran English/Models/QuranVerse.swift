//
//  QuranVerse.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class QuranVerse {
    var id: UUID = UUID()
    var surahNumber: Int = 0
    var verseNumber: Int = 0

    @Relationship(deleteRule: .cascade)
    var words: [QuranWord]? = []

    var fullEnglishTranslation: String = ""
    var fullArabicText: String = "" // Store Arabic text directly

    // Inverse relationship to Surah
    @Relationship(deleteRule: .nullify, inverse: \Surah.verses)
    var surah: Surah?

    init(surahNumber: Int, verseNumber: Int, words: [QuranWord]? = [], fullEnglishTranslation: String, fullArabicText: String = "", surah: Surah? = nil) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.verseNumber = verseNumber
        self.words = words
        self.fullEnglishTranslation = fullEnglishTranslation
        self.fullArabicText = fullArabicText
        self.surah = surah
    }
}
