//
//  SurahsView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct SurahsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var surahs: [Surah]
    @Query private var readingProgress: [ReadingProgress]
    @State private var preferences = UserPreferences.shared
    @State private var searchText = ""
    @State private var showSearch = false

    // Filtered surahs based on search text - searches both Arabic and English deeply
    private var filteredSurahs: [Surah] {
        if searchText.isEmpty {
            return surahs
        } else {
            return surahs.filter { surah in
                // Search by English surah name
                if surah.name.localizedCaseInsensitiveContains(searchText) {
                    return true
                }

                // Search by Arabic surah name
                if surah.arabicName.contains(searchText) {
                    return true
                }

                // Search by revelation type
                if surah.revelationType.localizedCaseInsensitiveContains(searchText) {
                    return true
                }

                // Deep search in verses
                if let verses = surah.verses {
                    return verses.contains { verse in
                        // Search in English translation
                        if verse.fullEnglishTranslation.localizedCaseInsensitiveContains(searchText) {
                            return true
                        }

                        // Search in full Arabic text
                        if verse.fullArabicText.contains(searchText) {
                            return true
                        }

                        // Search in individual word translations and Arabic
                        if let words = verse.words {
                            return words.contains { word in
                                // Search word English translation
                                if word.englishTranslation.localizedCaseInsensitiveContains(searchText) {
                                    return true
                                }

                                // Search word Arabic text
                                if word.arabic.contains(searchText) {
                                    return true
                                }

                                return false
                            }
                        }

                        return false
                    }
                }

                return false
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if surahs.isEmpty {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()

                        Text("Loading Quran...")
                            .font(.headline)
                            .foregroundColor(preferences.textColor.opacity(0.7))

                        Text("Loading all 114 Surahs with English translation")
                            .font(.caption)
                            .foregroundColor(preferences.textColor.opacity(0.6))
                    }
                    .frame(maxHeight: .infinity)
                    .background(preferences.backgroundColor.edgesIgnoringSafeArea(.all))
                    .onAppear {
                        // Auto-load data on first launch
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // Always reload to get fresh data with Arabic
                            loadSampleData()
                        }
                    }
                } else {
                    List {
                        ForEach(filteredSurahs.sorted(by: { $0.surahNumber < $1.surahNumber })) { surah in
                            NavigationLink(destination: ReadingModeView(surah: surah, preferences: preferences)) {
                                VStack(spacing: 8) {
                                    SurahRowView(surah: surah, preferences: preferences)

                                    // Progress bar - always show for all surahs
                                    if let progress = getProgress(for: surah.surahNumber) {
                                        SurahProgressBar(progress: progress.progressPercentage)
                                            .padding(.top, 4)
                                    } else {
                                        SurahProgressBar(progress: 0.0)
                                            .padding(.top, 4)
                                    }
                                }
                            }
                            .listRowBackground(preferences.backgroundColor)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(preferences.backgroundColor.edgesIgnoringSafeArea(.all))
                }
            }
            .navigationTitle("Quran")
            .searchable(text: $searchText, isPresented: $showSearch, prompt: "Search in Arabic or English...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        if !surahs.isEmpty {
                            Button(action: { showSearch.toggle() }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(UserPreferences.accentGreen)
                            }
                        }

                        Button(action: {
                            NSLog("🔄 Manual reload triggered - START")
                            loadSampleData()
                            NSLog("🔄 Manual reload triggered - COMPLETE")
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(UserPreferences.accentGreen)
                        }
                    }
                }
            }
            .preferredColorScheme(preferences.isDarkMode ? .dark : .light)
        }
    }

    private func loadSampleData() {
        NSLog("🔄 loadSampleData() started")

        // Clear existing data
        NSLog("🗑️ Clearing \(surahs.count) existing surahs")
        for surah in surahs {
            modelContext.delete(surah)
        }

        // Clear all reading progress
        NSLog("🗑️ Clearing \(readingProgress.count) progress records")
        for progress in readingProgress {
            modelContext.delete(progress)
        }

        // Load bundled content
        NSLog("📚 Loading bundled content...")
        let allSurahs = ComprehensiveQuranData.createAllSurahs()
        NSLog("📥 Inserting \(allSurahs.count) surahs into database")

        for surah in allSurahs {
            modelContext.insert(surah)
        }

        NSLog("💾 Saving to database...")
        try? modelContext.save()
        NSLog("✅ loadSampleData() completed")
    }

    private func getProgress(for surahNumber: Int) -> ReadingProgress? {
        return readingProgress.first(where: { $0.surahNumber == surahNumber })
    }
}

struct SurahRowView: View {
    let surah: Surah
    let preferences: UserPreferences

    var body: some View {
        HStack(spacing: 16) {
            // Surah number circle - Apple Fitness style
            ZStack {
                Circle()
                    .fill(UserPreferences.accentGreen.opacity(0.2))
                    .frame(width: 44, height: 44)

                Text("\(surah.surahNumber)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(UserPreferences.accentGreen)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if preferences.showEnglish {
                        Text(surah.name)
                            .font(.headline)
                            .foregroundColor(preferences.textColor)
                    }

                    Spacer()

                    if preferences.showArabic {
                        Text(surah.arabicName)
                            .font(.custom("Lateef", size: 18))
                            .foregroundColor(preferences.isDarkMode ? UserPreferences.darkArabicText : .black)
                    }
                }

                HStack {
                    Text(surah.revelationType)
                        .font(.caption)
                        .foregroundColor(preferences.textColor.opacity(0.6))

                    Circle()
                        .fill(UserPreferences.accentGreen)
                        .frame(width: 3, height: 3)

                    Text("\(surah.numberOfVerses) verses")
                        .font(.caption)
                        .foregroundColor(preferences.textColor.opacity(0.6))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Progress Bar Component
struct SurahProgressBar: View {
    let progress: Double
    @State private var preferences = UserPreferences.shared

    // Conditional color based on progress percentage
    private var progressColor: Color {
        if progress < 34 {
            return Color(red: 1.0, green: 0.27, blue: 0.23) // Red
        } else if progress < 67 {
            return Color(red: 1.0, green: 0.58, blue: 0.0) // Orange
        } else {
            return UserPreferences.accentGreen // Green
        }
    }

    // Ensure progress is between 0 and 100
    private var safeProgress: Double {
        return min(max(progress, 0.0), 100.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(safeProgress > 0 ? "Reading Progress" : "Not Started")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(preferences.textColor.opacity(0.5))

                Spacer()

                if safeProgress > 0 {
                    Text("\(Int(safeProgress))%")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(progressColor)
                }
            }

            // Progress bar with conditional gradient
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(preferences.textColor.opacity(0.1))
                    .frame(height: 6)

                // Progress fill with gradient
                if safeProgress > 0 {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        progressColor,
                                        progressColor.opacity(0.7)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(geometry.size.width * (safeProgress / 100), 0), height: 6)
                    }
                }
            }
            .frame(height: 6)
        }
    }
}
