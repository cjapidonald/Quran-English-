//
//  ContentView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var verses: [QuranVerse]
    @State private var isDataLoaded = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Content Preview")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)

                        Text("Load your own collection to explore it here.")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        Text("Tap any word to view its translation once data is available.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                    Divider()

                    // Display verses
                    if verses.isEmpty {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()

                            Text("Loading Quran...")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                    } else {
                        VStack(spacing: 24) {
                            ForEach(verses.sorted(by: { $0.verseNumber < $1.verseNumber })) { verse in
                                QuranVerseView(verse: verse)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Quran English")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if !isDataLoaded && verses.isEmpty {
                loadSampleData()
                isDataLoaded = true
            }
        }
    }

    private func loadSampleData() {
        // Don't load sample data in ContentView - let SurahsView handle it
        // This view is just for testing individual verses
    }
}

#Preview {
    ContentView()
        .modelContainer(for: QuranVerse.self, inMemory: true)
}
