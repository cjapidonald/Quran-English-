//
//  TappableWordView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct TappableWordView: View {
    let word: QuranWord
    let onTap: (QuranWord) -> Void
    @State private var preferences = UserPreferences.shared
    @State private var isPressed = false

    var body: some View {
        Text(word.arabic)
            .font(.custom("GeezaPro", size: preferences.arabicFontSize))
            .foregroundColor(UserPreferences.darkArabicText)
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
    }
}
