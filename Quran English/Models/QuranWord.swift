//
//  QuranWord.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class QuranWord {
    var arabic: String = ""
    var englishTranslation: String = ""
    var position: Int = 0

    // Inverse relationship to QuranVerse (replaces verseId)
    @Relationship(deleteRule: .nullify, inverse: \QuranVerse.words)
    var verse: QuranVerse?

    init(arabic: String, englishTranslation: String, position: Int, verse: QuranVerse? = nil) {
        self.arabic = arabic
        self.englishTranslation = englishTranslation
        self.position = position
        self.verse = verse
    }
}
