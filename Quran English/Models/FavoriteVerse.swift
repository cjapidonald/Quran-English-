//
//  FavoriteVerse.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteVerse {
    var id: UUID = UUID()
    var surahNumber: Int = 0
    var verseNumber: Int = 0
    var arabicText: String = ""
    var englishTranslation: String = ""
    var addedAt: Date = Date()

    init(surahNumber: Int, verseNumber: Int, arabicText: String, englishTranslation: String) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.verseNumber = verseNumber
        self.arabicText = arabicText
        self.englishTranslation = englishTranslation
        self.addedAt = Date()
    }
}
