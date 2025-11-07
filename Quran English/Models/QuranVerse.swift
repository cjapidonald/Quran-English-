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
    var id: UUID
    var surahNumber: Int
    var verseNumber: Int
    var words: [QuranWord]
    var fullEnglishTranslation: String

    init(surahNumber: Int, verseNumber: Int, words: [QuranWord], fullEnglishTranslation: String) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.verseNumber = verseNumber
        self.words = words
        self.fullEnglishTranslation = fullEnglishTranslation
    }

    var fullArabicText: String {
        words.map { $0.arabic }.joined(separator: " ")
    }
}
