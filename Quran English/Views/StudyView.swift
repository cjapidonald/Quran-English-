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
            ZStack {
                // Dark background
                AppColors.darkBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Custom tab selector with glass effect
                    HStack(spacing: 0) {
                        ForEach(0..<3) { index in
                            Button(action: { withAnimation(.spring()) { selectedTab = index } }) {
                                VStack(spacing: 4) {
                                    Image(systemName: tabIcon(for: index))
                                        .font(.system(size: 20, weight: .semibold))
                                    Text(tabTitle(for: index))
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(selectedTab == index ? tabColor(for: index) : AppColors.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedTab == index ?
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(tabColor(for: index).opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(tabColor(for: index).opacity(0.3), lineWidth: 1)
                                        ) : nil
                                )
                            }
                        }
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
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
            }
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
        }
    }

    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "note.text.badge.plus"
        case 1: return "heart.fill"
        case 2: return "folder.fill"
        default: return "note.text"
        }
    }

    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Notes"
        case 1: return "Favorites"
        case 2: return "Categories"
        default: return ""
        }
    }

    private func tabColor(for index: Int) -> Color {
        switch index {
        case 0: return AppColors.neonCyan
        case 1: return AppColors.neonPink
        case 2: return AppColors.neonYellow
        default: return AppColors.neonCyan
        }
    }

    private var myNotesView: some View {
        VStack {
            // Category filter
            if !categories.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            color: AppColors.neonGreen,
                            action: { selectedCategory = nil }
                        )

                        ForEach(categories) { category in
                            FilterChip(
                                title: category.name,
                                isSelected: selectedCategory?.id == category.id,
                                color: Color(hex: category.colorHex),
                                action: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 12)
            }

            if filteredNotes.isEmpty {
                EmptyStateView(
                    icon: "note.text.badge.plus",
                    title: "No notes yet",
                    subtitle: "Long press on any verse while reading to add a note",
                    color: AppColors.neonCyan
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredNotes.sorted(by: { $0.updatedAt > $1.updatedAt })) { note in
                            NoteRowView(note: note)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var favoritesView: some View {
        VStack {
            if favorites.isEmpty {
                EmptyStateView(
                    icon: "heart.fill",
                    title: "No favorites yet",
                    subtitle: "Double tap on any verse while reading to add to favorites",
                    color: AppColors.neonPink
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(favorites.sorted(by: { $0.addedAt > $1.addedAt })) { favorite in
                            FavoriteRowView(favorite: favorite)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var categoriesView: some View {
        VStack {
            if categories.isEmpty {
                VStack(spacing: 24) {
                    Image(systemName: "folder.fill.badge.plus")
                        .font(.system(size: 70))
                        .foregroundColor(AppColors.neonYellow)
                        .shadow(color: AppColors.neonYellow.opacity(0.5), radius: 10)

                    Text("No categories yet")
                        .font(.title2.bold())
                        .foregroundColor(AppColors.primaryText)

                    Text("Create categories to organize your notes")
                        .font(.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)

                    Button(action: { showNewCategoryAlert = true }) {
                        Label("Create Category", systemImage: "folder.badge.plus")
                    }
                    .vibrantButton(color: AppColors.neonYellow, fullWidth: false)
                }
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(categories) { category in
                            CategoryRowView(category: category)
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showNewCategoryAlert = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(AppColors.neonYellow)
                                .font(.system(size: 24))
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
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .black : AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? color.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                )
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 70))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: 10)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(AppColors.primaryText)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Note Row View
struct NoteRowView: View {
    let note: QuranNote

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.neonCyan)
                    Text("Surah \(note.surahNumber):\(note.verseNumber)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.neonCyan)
                }

                if let category = note.category {
                    Text(category.name)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(hex: category.colorHex))
                        )
                }

                Spacer()

                Text(note.updatedAt, style: .date)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppColors.tertiaryText)
            }

            Text(note.arabicText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .lineLimit(2)

            Text(note.userNote)
                .font(.system(size: 14))
                .foregroundColor(AppColors.secondaryText)
                .lineLimit(3)
        }
        .glassCard(cornerRadius: 16, padding: 16)
    }
}

// MARK: - Favorite Row View
struct FavoriteRowView: View {
    let favorite: FavoriteVerse

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 12))
                    Text("Surah \(favorite.surahNumber):\(favorite.verseNumber)")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(AppColors.neonPink)

                Spacer()

                Image(systemName: "heart.fill")
                    .foregroundColor(AppColors.neonPink)
                    .font(.system(size: 16))
                    .shadow(color: AppColors.neonPink.opacity(0.5), radius: 4)
            }

            Text(favorite.arabicText)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.primaryText)

            Text(favorite.englishTranslation)
                .font(.system(size: 14))
                .foregroundColor(AppColors.secondaryText)
        }
        .glassCard(cornerRadius: 16, padding: 16)
    }
}

// MARK: - Category Row View
struct CategoryRowView: View {
    let category: NoteCategory
    @Query private var notes: [QuranNote]

    var categoryNoteCount: Int {
        notes.filter { $0.category?.id == category.id }.count
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: category.colorHex).opacity(0.2))
                    .frame(width: 56, height: 56)

                Image(systemName: "folder.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: category.colorHex))
                    .shadow(color: Color(hex: category.colorHex).opacity(0.5), radius: 4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)

                Text("\(categoryNoteCount) note\(categoryNoteCount == 1 ? "" : "s")")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: category.colorHex))
                .font(.system(size: 14, weight: .bold))
        }
        .glassCard(cornerRadius: 16, padding: 16)
    }
}
