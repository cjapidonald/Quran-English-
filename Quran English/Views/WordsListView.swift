//
//  WordsListView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct WordsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedWord.savedAt, order: .reverse) private var savedWords: [SavedWord]
    @State private var preferences = UserPreferences.shared
    @State private var searchText = ""
    @State private var showOnlyUnmastered = false
    @State private var selectedWord: SavedWord?
    @State private var showEditSheet = false

    // Filtered words based on search and mastered toggle
    private var filteredWords: [SavedWord] {
        var words = savedWords

        if showOnlyUnmastered {
            words = words.filter { !$0.mastered }
        }

        if !searchText.isEmpty {
            words = words.filter { word in
                word.arabicWord.localizedCaseInsensitiveContains(searchText) ||
                word.englishTranslation.localizedCaseInsensitiveContains(searchText) ||
                word.surahName.localizedCaseInsensitiveContains(searchText)
            }
        }

        return words
    }

    var body: some View {
        NavigationView {
            Group {
                if savedWords.isEmpty {
                    emptyStateView
                } else {
                    wordsList
                }
            }
            .navigationTitle("Saved Words")
            .searchable(text: $searchText, prompt: "Search words...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showOnlyUnmastered.toggle() }) {
                        Image(systemName: showOnlyUnmastered ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(UserPreferences.accentGreen)
                    }
                }
            }
            .sheet(item: $selectedWord) { word in
                WordDetailSheet(word: word, modelContext: modelContext)
            }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(UserPreferences.darkText.opacity(0.5))

            Text("No Saved Words")
                .font(.headline)
                .foregroundColor(UserPreferences.darkText.opacity(0.7))

            Text("Tap on any word while reading\nto save it to your vocabulary list")
                .font(.caption)
                .foregroundColor(UserPreferences.darkText.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Words List
    private var wordsList: some View {
        List {
            ForEach(filteredWords) { word in
                WordRowView(word: word)
                    .listRowBackground(Color.black)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deleteWord(word)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            toggleMastered(word)
                        } label: {
                            Label(
                                word.mastered ? "Unmark" : "Master",
                                systemImage: word.mastered ? "checkmark.circle.fill" : "checkmark.circle"
                            )
                        }
                        .tint(UserPreferences.accentGreen)
                    }
                    .onTapGesture {
                        selectedWord = word
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Actions
    private func deleteWord(_ word: SavedWord) {
        modelContext.delete(word)
        try? modelContext.save()
    }

    private func toggleMastered(_ word: SavedWord) {
        word.mastered.toggle()
        try? modelContext.save()
    }
}

// MARK: - Word Row
struct WordRowView: View {
    let word: SavedWord
    @State private var preferences = UserPreferences.shared

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Arabic word
            Text(word.arabicWord)
                .font(.custom("Lateef", size: 32))
                .foregroundColor(preferences.arabicTextColor)
                .frame(width: 80, alignment: .trailing)

            VStack(alignment: .leading, spacing: 6) {
                // English translation
                Text(word.englishTranslation)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(preferences.textColor)

                // Surah reference
                HStack(spacing: 6) {
                    Image(systemName: "book")
                        .font(.system(size: 12))
                        .foregroundColor(UserPreferences.accentGreen.opacity(0.7))

                    if !word.surahName.isEmpty {
                        Text("\(word.surahName):\(word.verseNumber)")
                    } else {
                        Text("Surah \(word.surahNumber):\(word.verseNumber)")
                    }
                }
                .font(.caption)
                .foregroundColor(preferences.textColor.opacity(0.6))

                // Notes preview if exists
                if !word.notes.isEmpty {
                    Text(word.notes)
                        .font(.caption)
                        .foregroundColor(preferences.textColor.opacity(0.5))
                        .lineLimit(2)
                        .padding(.top, 4)
                }
            }

            Spacer()

            // Mastered indicator
            if word.mastered {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(UserPreferences.accentGreen)
                    .font(.system(size: 20))
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Word Detail Sheet
struct WordDetailSheet: View {
    let word: SavedWord
    let modelContext: ModelContext

    @State private var preferences = UserPreferences.shared
    @State private var notes: String
    @Environment(\.dismiss) private var dismiss

    init(word: SavedWord, modelContext: ModelContext) {
        self.word = word
        self.modelContext = modelContext
        _notes = State(initialValue: word.notes)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Arabic word
                    Text(word.arabicWord)
                        .font(.custom("Lateef", size: 48))
                        .foregroundColor(preferences.arabicTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } header: {
                    Text("Arabic")
                }

                Section {
                    Text(word.englishTranslation)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(UserPreferences.darkText)
                } header: {
                    Text("Translation")
                }

                Section {
                    if !word.surahName.isEmpty {
                        HStack {
                            Text("Surah")
                            Spacer()
                            Text("\(word.surahName) (\(word.surahNumber))")
                                .foregroundColor(.secondary)
                        }
                    } else {
                        HStack {
                            Text("Surah")
                            Spacer()
                            Text("\(word.surahNumber)")
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack {
                        Text("Verse")
                        Spacer()
                        Text("\(word.verseNumber)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Saved")
                        Spacer()
                        Text(word.savedAt, style: .date)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Reference")
                }

                Section {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .onChange(of: notes) { oldValue, newValue in
                            word.notes = newValue
                            try? modelContext.save()
                        }
                } header: {
                    Text("Personal Notes")
                } footer: {
                    Text("Add your own notes about this word to help you remember it")
                }

                Section {
                    Toggle(isOn: Binding(
                        get: { word.mastered },
                        set: { newValue in
                            word.mastered = newValue
                            try? modelContext.save()
                        }
                    )) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(UserPreferences.accentGreen)
                            Text("Mark as Mastered")
                        }
                    }
                } footer: {
                    Text("Mark this word as mastered when you've learned it well")
                }
            }
            .navigationTitle("Word Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
