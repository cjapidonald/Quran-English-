//
//  NoteCategory.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class NoteCategory {
    var id: UUID = UUID()
    var name: String = ""
    var colorHex: String = ""
    var createdAt: Date = Date()

    @Relationship(deleteRule: .nullify)
    var notes: [QuranNote]? = []

    init(name: String, colorHex: String) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.createdAt = Date()
    }
}
