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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var categories: [NoteCategory]

    @State private var noteText = ""
    @State private var selectedCategory: NoteCategory?
    @State private var showNewCategoryAlert = false
    @State private var newCategoryName = ""
    @State private var newCategoryColor = Color.blue

    var body: some View {
        NavigationView {
            Form {
                // Verse Reference
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Surah \(verse.surahNumber):\(verse.verseNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(verse.fullArabicText)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .trailing)

                        Text(verse.fullEnglishTranslation)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Verse")
                }

                // Category Selection
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        Text("None").tag(nil as NoteCategory?)
                        ForEach(categories) { category in
                            HStack {
                                Circle()
                                    .fill(Color(hex: category.colorHex))
                                    .frame(width: 12, height: 12)
                                Text(category.name)
                            }
                            .tag(category as NoteCategory?)
                        }
                    }

                    Button(action: { showNewCategoryAlert = true }) {
                        Label("Create New Category", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Category")
                }

                // Note Text
                Section {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 150)
                } header: {
                    Text("Your Note")
                } footer: {
                    Text("Write your thoughts, reflections, or reminders about this verse.")
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
                    createNewCategory()
                }
            } message: {
                Text("Enter a name for the new category")
            }
        }
    }

    private func createNewCategory() {
        guard !newCategoryName.isEmpty else { return }

        let colors = ["#3498db", "#e74c3c", "#2ecc71", "#f39c12", "#9b59b6", "#1abc9c"]
        let randomColor = colors.randomElement() ?? "#3498db"

        let newCategory = NoteCategory(name: newCategoryName, colorHex: randomColor)
        modelContext.insert(newCategory)

        selectedCategory = newCategory
        newCategoryName = ""

        try? modelContext.save()
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
