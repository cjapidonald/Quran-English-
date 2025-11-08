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
    @State private var showLoadDataAlert = false
    @State private var searchText = ""
    @State private var showSearch = false

    // Filtered surahs based on search text
    private var filteredSurahs: [Surah] {
        if searchText.isEmpty {
            return surahs
        } else {
            return surahs.filter { surah in
                // Search by surah name
                if surah.name.localizedCaseInsensitiveContains(searchText) {
                    return true
                }

                // Search by revelation type
                if surah.revelationType.localizedCaseInsensitiveContains(searchText) {
                    return true
                }

                // Search in verse translations
                if let verses = surah.verses {
                    return verses.contains { verse in
                        verse.fullEnglishTranslation.localizedCaseInsensitiveContains(searchText)
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
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(UserPreferences.darkText.opacity(0.5))

                        Text("No Surahs Available")
                            .font(.headline)
                            .foregroundColor(UserPreferences.darkText.opacity(0.7))

                        Text("Load sample data to get started")
                            .font(.caption)
                            .foregroundColor(UserPreferences.darkText.opacity(0.6))

                        Button(action: { showLoadDataAlert = true }) {
                            Label("Load Sample Data", systemImage: "arrow.down.circle.fill")
                                .padding()
                                .background(UserPreferences.accentGreen)
                                .foregroundColor(UserPreferences.darkBackground)
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .background(preferences.backgroundColor.edgesIgnoringSafeArea(.all))
                } else {
                    List {
                        ForEach(filteredSurahs.sorted(by: { $0.surahNumber < $1.surahNumber })) { surah in
                            NavigationLink(destination: ReadingModeView(surah: surah, preferences: preferences)) {
                                VStack(spacing: 8) {
                                    SurahRowView(surah: surah, preferences: preferences)

                                    // Progress bar - always show
                                    let progressValue = getProgress(for: surah.surahNumber)?.progressPercentage ?? 0.0
                                    if progressValue > 0 {
                                        SurahProgressBar(progress: progressValue)
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
            .searchable(text: $searchText, isPresented: $showSearch, prompt: "Search in English...")
            .toolbar {
                if !surahs.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: { showSearch.toggle() }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(UserPreferences.accentGreen)
                            }

                            Button(action: { showLoadDataAlert = true }) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(UserPreferences.accentGreen)
                            }
                        }
                    }
                }
            }
            .alert("Load Sample Data", isPresented: $showLoadDataAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Load") {
                    loadSampleData()
                }
            } message: {
                Text("This will load Al-Fatiha and Al-Ikhlas with word-by-word translations. Any existing data will be replaced.")
            }
            .preferredColorScheme(preferences.isDarkMode ? .dark : .light)
        }
    }

    private func loadSampleData() {
        // Clear existing data
        for surah in surahs {
            modelContext.delete(surah)
        }

        // Load sample surahs
        let sampleSurahs = SampleSurahData.createSampleSurahs()
        for surah in sampleSurahs {
            modelContext.insert(surah)
        }

        try? modelContext.save()
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
                    Text(surah.name)
                        .font(.headline)
                        .foregroundColor(preferences.textColor)

                    Spacer()

                    Text(surah.arabicName)
                        .font(.custom("Lateef", size: 18))
                        .foregroundColor(preferences.isDarkMode ? UserPreferences.darkArabicText : .black)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Reading Progress")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(UserPreferences.darkText.opacity(0.5))

                Spacer()

                Text("\(Int(progress))%")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(progressColor)
            }

            // Progress bar with conditional gradient
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)

                    // Progress fill with gradient
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
                        .frame(width: geometry.size.width * (progress / 100), height: 6)
                        .shadow(color: progressColor.opacity(0.5), radius: 4, x: 0, y: 0)
                }
            }
            .frame(height: 6)
        }
    }
}
