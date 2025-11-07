//
//  ReadingModeView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct ReadingModeView: View {
    let surah: Surah
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteVerse]
    @Bindable var preferences: UserPreferences

    @State private var showCustomization = false
    @State private var showChatGPT = false
    @State private var showAddNote = false
    @State private var selectedVerse: QuranVerse?
    @State private var showActionSheet = false
    @State private var showCopiedToast = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Surah Header
                VStack(spacing: 8) {
                    Text(surah.arabicName)
                        .font(.system(size: 32, weight: .bold))

                    Text(surah.name)
                        .font(.title2)
                        .foregroundColor(.secondary)

                    HStack {
                        Text(surah.revelationType)
                        Text("•")
                        Text("\(surah.numberOfVerses) verses")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                Divider()

                // Verses
                ForEach(surah.verses.sorted(by: { $0.verseNumber < $1.verseNumber })) { verse in
                    VerseCardView(
                        verse: verse,
                        preferences: preferences,
                        isFavorited: isFavorited(verse),
                        onDoubleTap: { toggleFavorite(verse) },
                        onLongPress: {
                            selectedVerse = verse
                            showActionSheet = true
                        }
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(preferences.backgroundColor)
        .navigationTitle(surah.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCustomization = true }) {
                    Image(systemName: "textformat.size")
                }
            }
        }
        .sheet(isPresented: $showCustomization) {
            ReadingCustomizationView(preferences: preferences)
        }
        .sheet(isPresented: $showChatGPT) {
            if let verse = selectedVerse {
                ChatGPTView(verse: verse)
            }
        }
        .sheet(isPresented: $showAddNote) {
            if let verse = selectedVerse {
                AddNoteView(verse: verse)
            }
        }
        .confirmationDialog("Verse Actions", isPresented: $showActionSheet, presenting: selectedVerse) { verse in
            Button("Ask ChatGPT") {
                showChatGPT = true
            }

            Button("Add to Notes") {
                showAddNote = true
            }

            Button("Copy Verse") {
                copyVerse(verse)
            }

            Button(isFavorited(verse) ? "Remove from Favorites" : "Add to Favorites") {
                toggleFavorite(verse)
            }

            Button("Cancel", role: .cancel) {}
        } message: { verse in
            Text("Surah \(verse.surahNumber):\(verse.verseNumber)")
        }
        .overlay(
            Group {
                if showCopiedToast {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Verse copied to clipboard")
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.bottom, 50)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        )
    }

    private func isFavorited(_ verse: QuranVerse) -> Bool {
        favorites.contains { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }
    }

    private func toggleFavorite(_ verse: QuranVerse) {
        if let existing = favorites.first(where: { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }) {
            modelContext.delete(existing)
        } else {
            let favorite = FavoriteVerse(
                surahNumber: verse.surahNumber,
                verseNumber: verse.verseNumber,
                arabicText: verse.fullArabicText,
                englishTranslation: verse.fullEnglishTranslation
            )
            modelContext.insert(favorite)
        }
        try? modelContext.save()
    }

    private func copyVerse(_ verse: QuranVerse) {
        let text = """
        Quran \(verse.surahNumber):\(verse.verseNumber)

        \(verse.fullArabicText)

        \(verse.fullEnglishTranslation)
        """

        UIPasteboard.general.string = text

        withAnimation {
            showCopiedToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopiedToast = false
            }
        }
    }
}

struct VerseCardView: View {
    let verse: QuranVerse
    let preferences: UserPreferences
    let isFavorited: Bool
    let onDoubleTap: () -> Void
    let onLongPress: () -> Void

    @State private var selectedWord: QuranWord?
    @State private var showTranslation = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            // Verse header with favorite indicator
            HStack {
                Text("Verse \(verse.verseNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if isFavorited {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Spacer()
            }

            // Arabic text with tappable words
            if preferences.showArabic {
                FlowLayout(spacing: 8) {
                    ForEach(Array(verse.words.enumerated()), id: \.element.position) { index, word in
                        TappableWordView(word: word) { tappedWord in
                            selectedWord = tappedWord
                            showTranslation = true
                        }
                        .foregroundColor(preferences.arabicTextColor)
                        .font(.system(size: preferences.fontSize))
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .secondarySystemBackground))
                )
            }

            // Full English translation
            if preferences.showEnglish {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Translation:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(verse.fullEnglishTranslation)
                        .font(.system(size: preferences.fontSize * 0.85))
                        .foregroundColor(preferences.englishTextColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .tertiarySystemBackground))
                )
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            onDoubleTap()
        }
        .onLongPressGesture {
            onLongPress()
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
    }
}
