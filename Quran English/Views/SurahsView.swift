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
    @State private var preferences = UserPreferences()
    @State private var showLoadDataAlert = false

    var body: some View {
        NavigationView {
            Group {
                if surahs.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)

                        Text("No Surahs Available")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text("Load sample data to get started")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button(action: { showLoadDataAlert = true }) {
                            Label("Load Sample Data", systemImage: "arrow.down.circle.fill")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(surahs.sorted(by: { $0.surahNumber < $1.surahNumber })) { surah in
                            NavigationLink(destination: ReadingModeView(surah: surah)) {
                                SurahRowView(surah: surah)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Quran")
            .toolbar {
                if !surahs.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showLoadDataAlert = true }) {
                            Image(systemName: "arrow.clockwise")
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
}

struct SurahRowView: View {
    let surah: Surah

    var body: some View {
        HStack(spacing: 16) {
            // Surah number circle
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 44, height: 44)

                Text("\(surah.surahNumber)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(surah.name)
                        .font(.headline)

                    Spacer()

                    Text(surah.arabicName)
                        .font(.headline)
                }

                HStack {
                    Text(surah.revelationType)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(surah.numberOfVerses) verses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
