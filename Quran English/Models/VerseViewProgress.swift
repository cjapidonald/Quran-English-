//
//  VerseViewProgress.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class VerseViewProgress {
    var id: UUID = UUID()
    var surahNumber: Int = 0
    var verseNumber: Int = 0
    var hasBeenViewed: Bool = false
    var viewedAt: Date = Date()

    init(surahNumber: Int, verseNumber: Int, hasBeenViewed: Bool = false) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.verseNumber = verseNumber
        self.hasBeenViewed = hasBeenViewed
        self.viewedAt = Date()
    }
}
