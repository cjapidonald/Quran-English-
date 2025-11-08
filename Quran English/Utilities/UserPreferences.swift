//
//  UserPreferences.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

@Observable
class UserPreferences {
    // Shared singleton instance
    static let shared = UserPreferences()

    // Dark theme colors (Apple Fitness style)
    static let darkBackground = Color(red: 0.0, green: 0.0, blue: 0.0) // Pure black like Fitness
    static let darkText = Color(red: 0.95, green: 0.95, blue: 0.97) // Off-white for readability
    static let darkArabicText = Color(red: 1.0, green: 1.0, blue: 1.0) // Pure white for Arabic
    static let accentGreen = Color(red: 0.49, green: 0.95, blue: 0.26) // Apple Fitness green (Exercise ring) - Stronger/Brighter
    static let accentPink = Color(red: 0.98, green: 0.07, blue: 0.31) // Apple Fitness pink (Move ring)

    // Faded colors for non-disturbing indicators
    static let fadedGreen = Color(red: 0.49, green: 0.95, blue: 0.26).opacity(0.4) // Subtle green for verse indicators
    static let fadedCyan = Color(red: 0.0, green: 0.78, blue: 0.75).opacity(0.5) // Subtle cyan for brain icons

    var textColor: Color {
        didSet { textColor.saveToUserDefaults(key: "textColor") }
    }

    var backgroundColor: Color {
        didSet { backgroundColor.saveToUserDefaults(key: "backgroundColor") }
    }

    var arabicFontSize: Double {
        didSet { UserDefaults.standard.set(arabicFontSize, forKey: "arabicFontSize") }
    }

    var englishFontSize: Double {
        didSet { UserDefaults.standard.set(englishFontSize, forKey: "englishFontSize") }
    }

    var showArabic: Bool {
        didSet { UserDefaults.standard.set(showArabic, forKey: "showArabic") }
    }

    var showEnglish: Bool {
        didSet { UserDefaults.standard.set(showEnglish, forKey: "showEnglish") }
    }

    var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode") }
    }

    init() {
        // Load saved preferences or use dark theme defaults (Apple Fitness style)
        self.isDarkMode = UserDefaults.standard.object(forKey: "isDarkMode") as? Bool ?? true
        self.textColor = Color.loadFromUserDefaults(key: "textColor", defaultColor: UserPreferences.darkText)
        self.backgroundColor = Color.loadFromUserDefaults(key: "backgroundColor", defaultColor: UserPreferences.darkBackground)
        self.arabicFontSize = UserDefaults.standard.object(forKey: "arabicFontSize") as? Double ?? 28.0
        self.englishFontSize = UserDefaults.standard.object(forKey: "englishFontSize") as? Double ?? 17.0
        self.showArabic = UserDefaults.standard.object(forKey: "showArabic") as? Bool ?? true
        self.showEnglish = UserDefaults.standard.object(forKey: "showEnglish") as? Bool ?? true
    }

    func resetToDefaults() {
        isDarkMode = true
        textColor = UserPreferences.darkText
        backgroundColor = UserPreferences.darkBackground
        arabicFontSize = 28.0
        englishFontSize = 17.0
        showArabic = true
        showEnglish = true
    }

    func toggleTheme() {
        isDarkMode.toggle()
        if isDarkMode {
            textColor = UserPreferences.darkText
            backgroundColor = UserPreferences.darkBackground
        } else {
            textColor = .black
            backgroundColor = .white
        }
    }

    func toggleThemeColors(to darkMode: Bool) {
        if darkMode {
            textColor = UserPreferences.darkText
            backgroundColor = UserPreferences.darkBackground
        } else {
            textColor = .black
            backgroundColor = .white
        }
    }
}
