//
//  StudyView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct StudyView: View {
    @Query private var notes: [QuranNote]
    @Query private var favorites: [FavoriteVerse]
    @Query private var categories: [NoteCategory]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTab = 0
    @State private var selectedCategory: NoteCategory?
    @State private var showNewCategoryAlert = false
    @State private var newCategoryName = ""

    var filteredNotes: [QuranNote] {
        if let category = selectedCategory {
            return notes.filter { $0.category?.id == category.id }
        }
        return notes
    }

    var body: some View {
        NavigationView {
            VStack {
                // Tab selector
                Picker("", selection: $selectedTab) {
                    Text("My Notes").tag(0)
                    Text("Favorites").tag(1)
                    Text("Categories").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Content based on selected tab
                Group {
                    switch selectedTab {
                    case 0:
                        myNotesView
                    case 1:
                        favoritesView
                    case 2:
                        categoriesView
                    default:
                        myNotesView
                    }
                }
            }
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var myNotesView: some View {
        VStack {
            // Category filter
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: { selectedCategory = nil }) {
                            Text("All")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedCategory == nil ? Color.blue : Color(uiColor: .secondarySystemBackground))
                                .foregroundColor(selectedCategory == nil ? .white : .primary)
                                .cornerRadius(20)
                        }

                        ForEach(categories) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category.name)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory?.id == category.id ? Color.blue : Color(uiColor: .secondarySystemBackground))
                                    .foregroundColor(selectedCategory?.id == category.id ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            }

            if filteredNotes.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "note.text")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    Text("No notes yet")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("Long press on any verse while reading to add a note")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                    ForEach(filteredNotes.sorted(by: { $0.updatedAt > $1.updatedAt })) { note in
                        NoteRowView(note: note)
                    }
                    .onDelete(perform: deleteNotes)
                }
            }
        }
    }

    private var favoritesView: some View {
        VStack {
            if favorites.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    Text("No favorites yet")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("Double tap on any verse while reading to add to favorites")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                    ForEach(favorites.sorted(by: { $0.addedAt > $1.addedAt })) { favorite in
                        FavoriteRowView(favorite: favorite)
                    }
                    .onDelete(perform: deleteFavorites)
                }
            }
        }
    }

    private var categoriesView: some View {
        VStack {
            if categories.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "folder")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    Text("No categories yet")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Button(action: { showNewCategoryAlert = true }) {
                        Label("Create Category", systemImage: "folder.badge.plus")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                List {
                    ForEach(categories) { category in
                        CategoryRowView(category: category)
                    }
                    .onDelete(perform: deleteCategories)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showNewCategoryAlert = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
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

    private func createCategory() {
        guard !newCategoryName.isEmpty else { return }
        let category = NoteCategory(name: newCategoryName)
        modelContext.insert(category)
        try? modelContext.save()
        newCategoryName = ""
    }

    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredNotes[index])
        }
        try? modelContext.save()
    }

    private func deleteFavorites(at offsets: IndexSet) {
        let sortedFavorites = favorites.sorted(by: { $0.addedAt > $1.addedAt })
        for index in offsets {
            modelContext.delete(sortedFavorites[index])
        }
        try? modelContext.save()
    }

    private func deleteCategories(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
        try? modelContext.save()
    }
}

struct NoteRowView: View {
    let note: QuranNote

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Surah \(note.surahNumber):\(note.verseNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let category = note.category {
                    Text(category.name)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }

                Spacer()

                Text(note.updatedAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(note.arabicText)
                .font(.system(size: 14))
                .lineLimit(2)

            Text(note.userNote)
                .font(.callout)
                .foregroundColor(.primary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
}

struct FavoriteRowView: View {
    let favorite: FavoriteVerse

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Surah \(favorite.surahNumber):\(favorite.verseNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Text(favorite.arabicText)
                .font(.system(size: 16))

            Text(favorite.englishTranslation)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct CategoryRowView: View {
    let category: NoteCategory
    @Query private var notes: [QuranNote]

    var categoryNoteCount: Int {
        notes.filter { $0.category?.id == category.id }.count
    }

    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(Color(hex: category.colorHex))

            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)

                Text("\(categoryNoteCount) note\(categoryNoteCount == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}
