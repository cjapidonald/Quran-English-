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
    var arabic: String
    var englishTranslation: String
    var position: Int
    var verseId: UUID

    init(arabic: String, englishTranslation: String, position: Int, verseId: UUID) {
        self.arabic = arabic
        self.englishTranslation = englishTranslation
        self.position = position
        self.verseId = verseId
    }
}
