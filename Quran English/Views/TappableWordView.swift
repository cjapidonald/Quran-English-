//
//  TappableWordView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct TappableWordView: View {
    let word: QuranWord
    let verse: QuranVerse?  // Optional verse context for long-press actions
    let onTap: (QuranWord) -> Void
    let onLongPress: ((QuranVerse) -> Void)?  // Optional long-press handler

    @State private var preferences = UserPreferences.shared
    @State private var isPressed = false

    // Convenience initializer without verse context (backward compatible)
    init(word: QuranWord, onTap: @escaping (QuranWord) -> Void) {
        self.word = word
        self.verse = nil
        self.onTap = onTap
        self.onLongPress = nil
    }

    // Full initializer with verse context
    init(word: QuranWord, verse: QuranVerse, onTap: @escaping (QuranWord) -> Void, onLongPress: @escaping (QuranVerse) -> Void) {
        self.word = word
        self.verse = verse
        self.onTap = onTap
        self.onLongPress = onLongPress
    }

    var body: some View {
        Text(word.arabic)
            .font(.custom("Lateef", size: preferences.arabicFontSize))
            .foregroundColor(preferences.arabicTextColor)
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
                onTap(word)
            }
            .onLongPressGesture {
                if let verse = verse, let handler = onLongPress {
                    handler(verse)
                }
            }
    }
}
