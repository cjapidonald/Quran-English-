//
//  Surah.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class Surah {
    var id: UUID
    var surahNumber: Int
    var name: String
    var arabicName: String
    var revelationType: String // "Meccan" or "Medinan"
    var numberOfVerses: Int
    var verses: [QuranVerse]

    init(surahNumber: Int, name: String, arabicName: String, revelationType: String, numberOfVerses: Int, verses: [QuranVerse] = []) {
        self.id = UUID()
        self.surahNumber = surahNumber
        self.name = name
        self.arabicName = arabicName
        self.revelationType = revelationType
        self.numberOfVerses = numberOfVerses
        self.verses = verses
    }
}
