//
//  AddNoteView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    let verse: QuranVerse
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [NoteCategory]

    @State private var noteText = ""
    @State private var selectedCategory: NoteCategory?
    @State private var showNewCategoryAlert = false
    @State private var newCategoryName = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Verse") {
                    Text("Surah \(verse.surahNumber), Verse \(verse.verseNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(verse.fullArabicText)
                        .font(.system(size: 16))

                    Text(verse.fullEnglishTranslation)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }

                Section("Category") {
                    if categories.isEmpty {
                        Text("No categories yet")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Select Category", selection: $selectedCategory) {
                            Text("None").tag(nil as NoteCategory?)
                            ForEach(categories) { category in
                                Text(category.name).tag(category as NoteCategory?)
                            }
                        }
                    }

                    Button(action: { showNewCategoryAlert = true }) {
                        Label("Create New Category", systemImage: "folder.badge.plus")
                    }
                }

                Section("Your Note") {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(noteText.isEmpty)
                }
            }
            .alert("New Category", isPresented: $showNewCategoryAlert) {
                TextField("Category Name", text: $newCategoryName)
                Button("Cancel", role: .cancel) {
                    newCategoryName = ""
                }
                Button("Create") {
                    createCategory()
                }
            }
        }
    }

    private func createCategory() {
        guard !newCategoryName.isEmpty else { return }
        let category = NoteCategory(name: newCategoryName)
        modelContext.insert(category)
        try? modelContext.save()
        selectedCategory = category
        newCategoryName = ""
    }

    private func saveNote() {
        let note = QuranNote(
            surahNumber: verse.surahNumber,
            verseNumber: verse.verseNumber,
            arabicText: verse.fullArabicText,
            englishTranslation: verse.fullEnglishTranslation,
            userNote: noteText,
            category: selectedCategory
        )
        modelContext.insert(note)
        try? modelContext.save()
        dismiss()
    }
}
