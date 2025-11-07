//
//  QuranNote.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class QuranNote {
    var id: UUID
    var surahNumber: Int
    var verseNumber: Int
    var arabicText: String
    var englishTranslation: String
    var userNote: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .nullify)
    var category: NoteCategory?

    init(surahNumber: Int, verseNumber: Int, arabicText: String, englishTranslation: String, userNote: String, category: NoteCategory? = nil) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.verseNumber = verseNumber
        self.arabicText = arabicText
        self.englishTranslation = englishTranslation
        self.userNote = userNote
        self.category = category
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
