//
//  ReadingProgress.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class ReadingProgress {
    var id: UUID = UUID()
    var surahNumber: Int = 0
    var surahName: String = ""
    var progressPercentage: Double = 0.0
    var lastReadAt: Date = Date()

    init(surahNumber: Int, surahName: String, progressPercentage: Double = 0.0) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.surahName = surahName
        self.progressPercentage = progressPercentage
        self.lastReadAt = Date()
    }
}
