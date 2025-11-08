//
//  WordTranslationPopup.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct WordTranslationPopup: View {
    let word: QuranWord
    let surahNumber: Int
    let surahName: String
    let verseNumber: Int
    let onDismiss: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Query private var savedWords: [SavedWord]

    @State private var preferences = UserPreferences.shared
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var showSavedConfirmation = false

    // Check if this word is already saved
    private var isWordSaved: Bool {
        savedWords.contains { savedWord in
            savedWord.arabicWord == word.arabic &&
            savedWord.surahNumber == surahNumber &&
            savedWord.verseNumber == verseNumber &&
            savedWord.wordPosition == word.position
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top accent bar
            HStack {
                Circle()
                    .fill(UserPreferences.accentGreen)
                    .frame(width: 8, height: 8)

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(preferences.textColor.opacity(0.7))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 6)

            // Arabic word - More compact with better contrast
            ZStack {
                // Background for word to stand out
                RoundedRectangle(cornerRadius: 12)
                    .fill(preferences.isDarkMode ? Color.black.opacity(0.5) : Color.white.opacity(0.8))
                    .frame(height: 60)
                    .padding(.horizontal, 16)

                Text(word.arabic)
                    .font(.custom("Lateef", size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(preferences.arabicTextColor)
                    .shadow(color: preferences.isDarkMode ? .black : .white, radius: 3, x: 0, y: 2)
                    .shadow(color: UserPreferences.accentGreen.opacity(0.6), radius: 12, x: 0, y: 0)
            }
            .padding(.vertical, 8)

            // Subtle divider with gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            UserPreferences.accentGreen.opacity(0.3),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)

            // English translation section
            VStack(alignment: .leading, spacing: 12) {
                Text("Translation")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(UserPreferences.accentGreen)
                    .textCase(.uppercase)
                    .tracking(1.2)

                Text(word.englishTranslation)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(preferences.textColor.opacity(0.95))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            // Save to Words button
            Button(action: saveWord) {
                HStack(spacing: 8) {
                    Image(systemName: isWordSaved ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 16))
                    Text(isWordSaved ? "Saved to Words" : "Save to Words")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(isWordSaved ? UserPreferences.accentGreen : preferences.textColor.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isWordSaved ? UserPreferences.accentGreen.opacity(0.2) : preferences.textColor.opacity(0.1))
                )
            }
            .disabled(isWordSaved)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            // Tap anywhere to close hint
            Text("Tap anywhere to close")
                .font(.caption2)
                .foregroundColor(preferences.textColor.opacity(0.4))
                .padding(.bottom, 12)
        }
        .frame(maxWidth: 300)
        .background(
            // Glassmorphism effect
            ZStack {
                // Translucent background with blur
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: preferences.isDarkMode ? [
                                        Color.black.opacity(0.7),
                                        Color(red: 0.1, green: 0.1, blue: 0.15).opacity(0.8)
                                    ] : [
                                        Color.white.opacity(0.9),
                                        Color(red: 0.95, green: 0.95, blue: 0.97).opacity(0.95)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )

                // Subtle border with gradient
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                UserPreferences.accentGreen.opacity(0.5),
                                UserPreferences.accentGreen.opacity(0.1),
                                preferences.textColor.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )

                // Top highlight for glass effect
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                preferences.textColor.opacity(0.15),
                                .clear
                            ]),
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            }
        )
        .shadow(color: UserPreferences.accentGreen.opacity(0.2), radius: 30, x: 0, y: 10)
        .shadow(color: preferences.isDarkMode ? .black.opacity(0.3) : .gray.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(40)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }

    private func saveWord() {
        // Don't save if already saved
        guard !isWordSaved else { return }

        let savedWord = SavedWord(
            arabicWord: word.arabic,
            englishTranslation: word.englishTranslation,
            surahNumber: surahNumber,
            surahName: surahName,
            verseNumber: verseNumber,
            wordPosition: word.position
        )

        modelContext.insert(savedWord)
        try? modelContext.save()

        // Show brief confirmation
        withAnimation {
            showSavedConfirmation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSavedConfirmation = false
            }
        }
    }
}
