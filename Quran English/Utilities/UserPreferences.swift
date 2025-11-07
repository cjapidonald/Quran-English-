//
//  UserPreferences.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

@Observable
class UserPreferences {
    var arabicTextColor: Color {
        didSet { arabicTextColor.saveToUserDefaults(key: "arabicTextColor") }
    }

    var englishTextColor: Color {
        didSet { englishTextColor.saveToUserDefaults(key: "englishTextColor") }
    }

    var backgroundColor: Color {
        didSet { backgroundColor.saveToUserDefaults(key: "backgroundColor") }
    }

    var fontSize: Double {
        didSet { UserDefaults.standard.set(fontSize, forKey: "fontSize") }
    }

    var showArabic: Bool {
        didSet { UserDefaults.standard.set(showArabic, forKey: "showArabic") }
    }

    var showEnglish: Bool {
        didSet { UserDefaults.standard.set(showEnglish, forKey: "showEnglish") }
    }

    init() {
        // Load saved preferences or use defaults
        self.arabicTextColor = Color.loadFromUserDefaults(key: "arabicTextColor", defaultColor: .black)
        self.englishTextColor = Color.loadFromUserDefaults(key: "englishTextColor", defaultColor: Color(.darkGray))
        self.backgroundColor = Color.loadFromUserDefaults(key: "backgroundColor", defaultColor: .white)
        self.fontSize = UserDefaults.standard.object(forKey: "fontSize") as? Double ?? 18.0
        self.showArabic = UserDefaults.standard.object(forKey: "showArabic") as? Bool ?? true
        self.showEnglish = UserDefaults.standard.object(forKey: "showEnglish") as? Bool ?? true
    }

    func resetToDefaults() {
        arabicTextColor = .black
        englishTextColor = Color(.darkGray)
        backgroundColor = .white
        fontSize = 18.0
        showArabic = true
        showEnglish = true
    }
}
