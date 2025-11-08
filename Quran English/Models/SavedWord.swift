//
//  SavedWord.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class SavedWord {
    var id: UUID = UUID()
    var arabicWord: String = ""
    var englishTranslation: String = ""
    var surahNumber: Int = 0
    var surahName: String = ""
    var verseNumber: Int = 0
    var wordPosition: Int = 0
    var savedAt: Date = Date()
    var notes: String = "" // User can add personal notes about the word
    var mastered: Bool = false // User can mark words as mastered

    init(
        arabicWord: String,
        englishTranslation: String,
        surahNumber: Int,
        surahName: String,
        verseNumber: Int,
        wordPosition: Int,
        notes: String = "",
        mastered: Bool = false
    ) {
        self.id = UUID()
        self.arabicWord = arabicWord
        self.englishTranslation = englishTranslation
        self.surahNumber = surahNumber
        self.surahName = surahName
        self.verseNumber = verseNumber
        self.wordPosition = wordPosition
        self.savedAt = Date()
        self.notes = notes
        self.mastered = mastered
    }
}
