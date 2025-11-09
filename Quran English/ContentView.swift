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
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)

                            Text("No verses loaded")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Button(action: loadSampleData) {
                                Label("Load Sample Data", systemImage: "arrow.down.circle.fill")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadSampleData) {
                        Label("Reload", systemImage: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            if !isDataLoaded && verses.isEmpty {
                loadSampleData()
                isDataLoaded = true
            }
        }
    }

    private func loadSampleData() {
        // Clear existing verses
        for verse in verses {
            modelContext.delete(verse)
        }

        // Load placeholder sample data
        let sampleVerses = SampleQuranData.createSampleVerses()
        for verse in sampleVerses {
            modelContext.insert(verse)
        }

        try? modelContext.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: QuranVerse.self, inMemory: true)
}
