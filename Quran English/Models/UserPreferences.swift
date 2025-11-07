//
//  UserPreferences.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation
import SwiftUI

class UserPreferences: ObservableObject {
    @Published var arabicTextColor: Color {
        didSet {
            UserDefaults.standard.set(arabicTextColor.toHex(), forKey: "arabicTextColor")
        }
    }

    @Published var englishTextColor: Color {
        didSet {
            UserDefaults.standard.set(englishTextColor.toHex(), forKey: "englishTextColor")
        }
    }

    @Published var backgroundColor: Color {
        didSet {
            UserDefaults.standard.set(backgroundColor.toHex(), forKey: "backgroundColor")
        }
    }

    @Published var fontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
    }

    @Published var showArabic: Bool {
        didSet {
            UserDefaults.standard.set(showArabic, forKey: "showArabic")
        }
    }

    @Published var showEnglish: Bool {
        didSet {
            UserDefaults.standard.set(showEnglish, forKey: "showEnglish")
        }
    }

    init() {
        // Dark theme defaults
        self.arabicTextColor = Color(hex: UserDefaults.standard.string(forKey: "arabicTextColor") ?? "#FFFFFF")
        self.englishTextColor = Color(hex: UserDefaults.standard.string(forKey: "englishTextColor") ?? "#99CCFF")
        self.backgroundColor = Color(hex: UserDefaults.standard.string(forKey: "backgroundColor") ?? "#12121E")
        self.fontSize = CGFloat(UserDefaults.standard.double(forKey: "fontSize") != 0 ? UserDefaults.standard.double(forKey: "fontSize") : 18.0)
        self.showArabic = UserDefaults.standard.object(forKey: "showArabic") as? Bool ?? true
        self.showEnglish = UserDefaults.standard.object(forKey: "showEnglish") as? Bool ?? true
    }

    func reset() {
        // Reset to dark theme defaults
        arabicTextColor = .white
        englishTextColor = Color(hex: "#99CCFF")
        backgroundColor = Color(hex: "#12121E")
        fontSize = 18.0
        showArabic = true
        showEnglish = true
    }
}

// Color extensions
extension Color {
    func toHex() -> String {
        let components = UIColor(self).cgColor.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = components?[2] ?? 0
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
