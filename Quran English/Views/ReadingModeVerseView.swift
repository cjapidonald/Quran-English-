//
//  ReadingModeVerseView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

enum VerseAction {
    case askChatGPT
    case addToNotes
    case copy
    case addToFavorites
}

struct ReadingModeVerseView: View {
    let verse: QuranVerse
    @ObservedObject var preferences: UserPreferences
    @Environment(\.modelContext) private var modelContext

    @State private var selectedWord: QuranWord?
    @State private var showTranslation = false
    @State private var showActionSheet = false
    @State private var showChatGPT = false
    @State private var showAddNote = false
    @State private var isFavorite = false
    @State private var showCopiedAlert = false
    @Query private var favorites: [FavoriteVerse]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Verse header
            HStack {
                Text("Verse \(verse.verseNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            // Arabic text
            if preferences.showArabic {
                FlowLayout(spacing: 8) {
                    ForEach(Array(verse.words.enumerated()), id: \.element.position) { index, word in
                        TappableWordView(word: word) { tappedWord in
                            selectedWord = tappedWord
                            showTranslation = true
                        }
                        .foregroundColor(preferences.arabicTextColor)
                        .font(.system(size: preferences.fontSize + 4))
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(preferences.backgroundColor.opacity(0.5))
                )
            }

            // English translation
            if preferences.showEnglish {
                Text(verse.fullEnglishTranslation)
                    .font(.system(size: preferences.fontSize))
                    .foregroundColor(preferences.englishTextColor)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(preferences.backgroundColor.opacity(0.3))
                    )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            // Double tap - add to favorites
            toggleFavorite()
        }
        .onLongPressGesture {
            // Long press - show action sheet
            showActionSheet = true
        }
        .confirmationDialog("Verse Actions", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("Ask ChatGPT") {
                showChatGPT = true
            }
            Button("Add to Notes") {
                showAddNote = true
            }
            Button("Copy Verse") {
                copyVerse()
            }
            Button(isFavorite ? "Remove from Favorites" : "Add to Favorites") {
                toggleFavorite()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showChatGPT) {
            ChatGPTView(verse: verse)
        }
        .sheet(isPresented: $showAddNote) {
            AddNoteView(verse: verse)
        }
        .overlay(
            Group {
                if showTranslation, let word = selectedWord {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showTranslation = false
                            selectedWord = nil
                        }

                    WordTranslationPopup(word: word) {
                        showTranslation = false
                        selectedWord = nil
                    }
                }
            }
        )
        .overlay(
            Group {
                if showCopiedAlert {
                    VStack {
                        Spacer()
                        Text("Verse copied to clipboard")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 50)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        )
        .onAppear {
            checkIfFavorite()
        }
    }

    private func toggleFavorite() {
        if isFavorite {
            // Remove from favorites
            if let favorite = favorites.first(where: { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }) {
                modelContext.delete(favorite)
            }
            isFavorite = false
        } else {
            // Add to favorites
            let favorite = FavoriteVerse(
                surahNumber: verse.surahNumber,
                verseNumber: verse.verseNumber,
                arabicText: verse.fullArabicText,
                englishTranslation: verse.fullEnglishTranslation
            )
            modelContext.insert(favorite)
            isFavorite = true
        }
        try? modelContext.save()
    }

    private func copyVerse() {
        let text = """
        \(verse.fullArabicText)

        \(verse.fullEnglishTranslation)

        - Surah \(verse.surahNumber), Verse \(verse.verseNumber)
        """
        UIPasteboard.general.string = text

        withAnimation {
            showCopiedAlert = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopiedAlert = false
            }
        }
    }

    private func checkIfFavorite() {
        isFavorite = favorites.contains(where: { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber })
    }
}
