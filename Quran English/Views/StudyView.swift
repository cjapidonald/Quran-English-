//
//  StudyView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

enum StudySection: String, CaseIterable {
    case words = "Words"
    case notes = "My Notes"
    case favorites = "Favorites"
    case categories = "Categories"
}

struct StudyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [QuranNote]
    @Query private var favorites: [FavoriteVerse]
    @Query private var categories: [NoteCategory]
    @State private var preferences = UserPreferences.shared

    @State private var selectedSection: StudySection = .words
    @State private var selectedCategoryFilter: NoteCategory?
    @State private var showNewCategoryAlert = false
    @State private var newCategoryName = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented Picker
                Picker("Section", selection: $selectedSection) {
                    ForEach(StudySection.allCases, id: \.self) { section in
                        Text(section.rawValue).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // Content
                Group {
                    switch selectedSection {
                    case .words:
                        WordsListView()
                    case .notes:
                        NotesListView(
                            notes: filteredNotes,
                            categories: categories,
                            selectedCategory: $selectedCategoryFilter,
                            onDeleteNote: deleteNote
                        )
                    case .favorites:
                        FavoritesListView(
                            favorites: favorites.sorted(by: { $0.addedAt > $1.addedAt }),
                            onDeleteFavorite: deleteFavorite
                        )
                    case .categories:
                        CategoriesListView(
                            categories: categories.sorted(by: { $0.name < $1.name }),
                            onDeleteCategory: deleteCategory,
                            onCreateCategory: { showNewCategoryAlert = true }
                        )
                    }
                }
            }
            .navigationTitle("Study")
            .background(preferences.backgroundColor.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(preferences.isDarkMode ? .dark : .light)
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

    private var filteredNotes: [QuranNote] {
        if let category = selectedCategoryFilter {
            return notes.filter { $0.category?.id == category.id }.sorted(by: { $0.createdAt > $1.createdAt })
        }
        return notes.sorted(by: { $0.createdAt > $1.createdAt })
    }

    private func deleteNote(_ note: QuranNote) {
        modelContext.delete(note)
        try? modelContext.save()
    }

    private func deleteFavorite(_ favorite: FavoriteVerse) {
        modelContext.delete(favorite)
        try? modelContext.save()
    }

    private func deleteCategory(_ category: NoteCategory) {
        modelContext.delete(category)
        try? modelContext.save()
    }

    private func createNewCategory() {
        guard !newCategoryName.isEmpty else { return }

        let colors = ["#3498db", "#e74c3c", "#2ecc71", "#f39c12", "#9b59b6", "#1abc9c"]
        let randomColor = colors.randomElement() ?? "#3498db"

        let newCategory = NoteCategory(name: newCategoryName, colorHex: randomColor)
        modelContext.insert(newCategory)

        newCategoryName = ""
        try? modelContext.save()
    }
}

// MARK: - Notes List View
struct NotesListView: View {
    let notes: [QuranNote]
    let categories: [NoteCategory]
    @Binding var selectedCategory: NoteCategory?
    let onDeleteNote: (QuranNote) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Category filter chips
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            color: .blue
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(categories) { category in
                            FilterChip(
                                title: category.name,
                                isSelected: selectedCategory?.id == category.id,
                                color: Color(hex: category.colorHex)
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                Divider()
            }

            // Notes list
            if notes.isEmpty {
                EmptyStateView(
                    icon: "note.text",
                    title: "No Notes Yet",
                    message: "Long press on any verse to add a note"
                )
            } else {
                List {
                    ForEach(notes) { note in
                        NoteRowView(note: note)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            onDeleteNote(notes[index])
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Favorites List View
struct FavoritesListView: View {
    let favorites: [FavoriteVerse]
    let onDeleteFavorite: (FavoriteVerse) -> Void

    var body: some View {
        if favorites.isEmpty {
            EmptyStateView(
                icon: "heart",
                title: "No Favorites Yet",
                message: "Double tap on any verse to add it to favorites"
            )
        } else {
            List {
                ForEach(favorites) { favorite in
                    FavoriteRowView(favorite: favorite)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        onDeleteFavorite(favorites[index])
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Categories List View
struct CategoriesListView: View {
    let categories: [NoteCategory]
    let onDeleteCategory: (NoteCategory) -> Void
    let onCreateCategory: () -> Void

    var body: some View {
        VStack {
            if categories.isEmpty {
                EmptyStateView(
                    icon: "folder",
                    title: "No Categories Yet",
                    message: "Create categories to organize your notes"
                )
            } else {
                List {
                    ForEach(categories) { category in
                        CategoryRowView(category: category)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            onDeleteCategory(categories[index])
                        }
                    }
                }
                .listStyle(.plain)
            }

            // Create button at bottom
            Button(action: onCreateCategory) {
                Label("Create New Category", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(UserPreferences.accentGreen)
                    .foregroundColor(UserPreferences.darkBackground)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : Color(uiColor: .systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct NoteRowView: View {
    let note: QuranNote

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Surah \(note.surahNumber):\(note.verseNumber)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)

                if let category = note.category {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(hex: category.colorHex))
                            .frame(width: 8, height: 8)
                        Text(category.name)
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color(hex: category.colorHex).opacity(0.1))
                    .cornerRadius(8)
                }

                Spacer()

                Text(note.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(note.arabicText)
                .font(.system(size: 14))
                .lineLimit(1)
                .foregroundColor(.secondary)

            Text(note.userNote)
                .font(.body)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

struct FavoriteRowView: View {
    let favorite: FavoriteVerse

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundColor(.red)

                Text("Surah \(favorite.surahNumber):\(favorite.verseNumber)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)

                Spacer()

                Text(favorite.addedAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(favorite.arabicText)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .trailing)

            Text(favorite.englishTranslation)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct CategoryRowView: View {
    let category: NoteCategory

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "folder.fill")
                .font(.title2)
                .foregroundColor(Color(hex: category.colorHex))

            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)

                Text("\(category.notes?.count ?? 0) notes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}
