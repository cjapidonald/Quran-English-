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
            VStack {
                if surahs.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)

                        Text("No Surahs loaded")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Button(action: loadSampleData) {
                            Label("Load Sample Surahs", systemImage: "arrow.down.circle.fill")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(surahs.sorted(by: { $0.surahNumber < $1.surahNumber })) { surah in
                            NavigationLink(destination: ReadingModeView(surah: surah)) {
                                SurahRowView(surah: surah)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Surahs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadSampleData) {
                        Label("Reload", systemImage: "arrow.clockwise")
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

    var body: some View {
        HStack(spacing: 16) {
            // Surah number in circle
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 50, height: 50)

                Text("\(surah.surahNumber)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            // Surah info
            VStack(alignment: .leading, spacing: 4) {
                Text(surah.name)
                    .font(.headline)

                Text(surah.arabicName)
                    .font(.title3)

                HStack {
                    Text(surah.revelationType)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("•")
                        .foregroundColor(.secondary)

                    Text("\(surah.numberOfVerses) verses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}
