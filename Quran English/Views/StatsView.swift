//
//  StatsView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var readingProgress: [ReadingProgress]
    @Query private var memorizedVerses: [MemorizedVerse]
    @Query private var surahs: [Surah]
    @State private var preferences = UserPreferences.shared

    // Total verses in Quran (approximate - can be made exact with full data)
    private let totalQuranVerses = 6236

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Hatma Dashboard")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(preferences.textColor)

                        Text("Track your Quran journey")
                            .font(.caption)
                            .foregroundColor(preferences.textColor.opacity(0.6))
                    }
                    .padding(.top, 20)

                    // Reading Progress Donut
                    VStack(spacing: 16) {
                        Text("Reading Progress")
                            .font(.headline)
                            .foregroundColor(preferences.textColor)

                        ZStack {
                            // Background circle
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 20)
                                .frame(width: 200, height: 200)

                            // Progress circle
                            Circle()
                                .trim(from: 0, to: readingPercentage / 100)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            UserPreferences.accentPink,
                                            UserPreferences.accentPink.opacity(0.7)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .shadow(color: UserPreferences.accentPink.opacity(0.5), radius: 10, x: 0, y: 0)

                            // Center text
                            VStack(spacing: 4) {
                                Text("\(Int(readingPercentage))%")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(UserPreferences.accentPink)

                                Text("\(versesRead) / \(totalQuranVerses)")
                                    .font(.caption)
                                    .foregroundColor(preferences.textColor.opacity(0.6))
                            }
                        }

                        Text("Verses Read")
                            .font(.caption)
                            .foregroundColor(preferences.textColor.opacity(0.6))
                    }
                    .padding(.vertical, 20)

                    Divider()
                        .background(preferences.textColor.opacity(0.1))

                    // Memorization Progress Donut
                    VStack(spacing: 16) {
                        Text("Memorization Progress")
                            .font(.headline)
                            .foregroundColor(preferences.textColor)

                        ZStack {
                            // Background circle
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 20)
                                .frame(width: 200, height: 200)

                            // Progress circle
                            Circle()
                                .trim(from: 0, to: memorizationPercentage / 100)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            UserPreferences.accentGreen,
                                            UserPreferences.accentGreen.opacity(0.7)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .shadow(color: UserPreferences.accentGreen.opacity(0.5), radius: 10, x: 0, y: 0)

                            // Center text
                            VStack(spacing: 4) {
                                Text("\(Int(memorizationPercentage))%")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(UserPreferences.accentGreen)

                                Text("\(memorizedVerses.count) / \(totalQuranVerses)")
                                    .font(.caption)
                                    .foregroundColor(preferences.textColor.opacity(0.6))
                            }
                        }

                        Text("Verses Memorized")
                            .font(.caption)
                            .foregroundColor(preferences.textColor.opacity(0.6))
                    }
                    .padding(.vertical, 20)

                    // Stats cards
                    VStack(spacing: 12) {
                        StatsCard(
                            icon: "book.fill",
                            title: "Surahs Started",
                            value: "\(surahsStarted)",
                            color: UserPreferences.accentPink
                        )

                        StatsCard(
                            icon: "checkmark.circle.fill",
                            title: "Surahs Completed",
                            value: "\(surahsCompleted)",
                            color: UserPreferences.accentGreen
                        )

                        StatsCard(
                            icon: "brain.head.profile",
                            title: "Memorization Streak",
                            value: "\(memorizedVerses.count) verses",
                            color: Color(red: 0.0, green: 0.78, blue: 0.75)
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
            .background(preferences.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Stats")
            .preferredColorScheme(preferences.isDarkMode ? .dark : .light)
        }
    }

    private var versesRead: Int {
        // Calculate based on reading progress
        var total = 0
        for progress in readingProgress {
            if let surah = surahs.first(where: { $0.surahNumber == progress.surahNumber }) {
                total += Int((progress.progressPercentage / 100.0) * Double(surah.numberOfVerses))
            }
        }
        return total
    }

    private var readingPercentage: Double {
        return min((Double(versesRead) / Double(totalQuranVerses)) * 100, 100)
    }

    private var memorizationPercentage: Double {
        return min((Double(memorizedVerses.count) / Double(totalQuranVerses)) * 100, 100)
    }

    private var surahsStarted: Int {
        return readingProgress.filter { $0.progressPercentage > 0 }.count
    }

    private var surahsCompleted: Int {
        return readingProgress.filter { $0.progressPercentage >= 100 }.count
    }
}

// MARK: - Stats Card Component
struct StatsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(UserPreferences.darkText.opacity(0.6))

                Text(value)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(UserPreferences.darkText)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
