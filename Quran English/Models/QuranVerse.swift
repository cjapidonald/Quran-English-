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

    // Inverse relationship to Surah
    @Relationship(deleteRule: .nullify, inverse: \Surah.verses)
    var surah: Surah?

    init(surahNumber: Int, verseNumber: Int, words: [QuranWord]? = [], fullEnglishTranslation: String, surah: Surah? = nil) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.verseNumber = verseNumber
        self.words = words
        self.fullEnglishTranslation = fullEnglishTranslation
        self.surah = surah
    }

    var fullArabicText: String {
        words?.map { $0.arabic }.joined(separator: " ") ?? ""
    }
}
