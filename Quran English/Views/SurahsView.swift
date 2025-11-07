//
//  SurahsView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct SurahsView: View {
    @Query private var surahs: [Surah]
    @Environment(\.modelContext) private var modelContext
    @State private var isDataLoaded = false

    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
                AppColors.darkBackground
                    .ignoresSafeArea()

                if surahs.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 70))
                            .foregroundColor(AppColors.neonCyan)
                            .shadow(color: AppColors.neonCyan.opacity(0.5), radius: 10)

                        Text("No Surahs loaded")
                            .font(.title2.bold())
                            .foregroundColor(AppColors.primaryText)

                        Text("Load sample data to get started")
                            .font(.subheadline)
                            .foregroundColor(AppColors.secondaryText)

                        Button(action: loadSampleData) {
                            Label("Load Sample Surahs", systemImage: "arrow.down.circle.fill")
                        }
                        .vibrantButton(color: AppColors.neonCyan, fullWidth: false)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(surahs.sorted(by: { $0.surahNumber < $1.surahNumber }).enumerated()), id: \.element.id) { index, surah in
                                NavigationLink(destination: ReadingModeView(surah: surah)) {
                                    SurahRowView(surah: surah, index: index)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Surahs")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadSampleData) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(AppColors.neonCyan)
                    }
                }
            }
            .onAppear {
                if !isDataLoaded && surahs.isEmpty {
                    loadSampleData()
                    isDataLoaded = true
                }
            }
        }
    }

    private func loadSampleData() {
        // Clear existing surahs
        for surah in surahs {
            modelContext.delete(surah)
        }

        // Load sample data
        let sampleSurahs = SampleSurahData.createSampleSurahs()
        for surah in sampleSurahs {
            modelContext.insert(surah)
        }

        try? modelContext.save()
    }
}

struct SurahRowView: View {
    let surah: Surah
    let index: Int

    // Cycle through vibrant colors
    var accentColor: Color {
        let colors = [AppColors.neonGreen, AppColors.neonCyan, AppColors.neonPink, AppColors.neonPurple, AppColors.neonOrange]
        return colors[index % colors.count]
    }

    var body: some View {
        HStack(spacing: 16) {
            // Neon ring with surah number
            NeonRing(number: surah.surahNumber, color: accentColor, size: 56)

            // Surah info
            VStack(alignment: .leading, spacing: 6) {
                Text(surah.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.primaryText)

                Text(surah.arabicName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(accentColor)

                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: surah.revelationType == "Meccan" ? "moon.fill" : "building.2.fill")
                            .font(.system(size: 10))
                        Text(surah.revelationType)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(AppColors.secondaryText)

                    Text("•")
                        .foregroundColor(AppColors.tertiaryText)
                        .font(.caption)

                    HStack(spacing: 4) {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 10))
                        Text("\(surah.numberOfVerses) verses")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(accentColor)
                .font(.system(size: 14, weight: .bold))
        }
        .glassCard(cornerRadius: 20, padding: 16)
    }
}
