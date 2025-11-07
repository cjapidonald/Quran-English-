//
//  ReadingModeView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct ReadingModeView: View {
    let surah: Surah
    @StateObject private var preferences = UserPreferences()
    @State private var showCustomization = false

    var body: some View {
        ZStack {
            // Background color
            preferences.backgroundColor
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 24) {
                    // Surah header
                    VStack(spacing: 12) {
                        Text(surah.arabicName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(preferences.arabicTextColor)

                        Text(surah.name)
                            .font(.title2)
                            .foregroundColor(preferences.englishTextColor)

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

                        Divider()
                            .padding(.horizontal)
                    }
                    .padding(.top)

                    // Verses
                    ForEach(surah.verses.sorted(by: { $0.verseNumber < $1.verseNumber })) { verse in
                        ReadingModeVerseView(verse: verse, preferences: preferences)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(surah.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCustomization.toggle() }) {
                    Image(systemName: "textformat.size")
                }
            }
        }
        .sheet(isPresented: $showCustomization) {
            CustomizationView(preferences: preferences)
        }
    }
}

struct CustomizationView: View {
    @ObservedObject var preferences: UserPreferences
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Display Options") {
                    Toggle("Show Arabic", isOn: $preferences.showArabic)
                    Toggle("Show English", isOn: $preferences.showEnglish)
                }

                Section("Font Size") {
                    HStack {
                        Text("A")
                            .font(.caption)

                        Slider(value: $preferences.fontSize, in: 12...32, step: 1)

                        Text("A")
                            .font(.title)
                    }

                    Text("Current size: \(Int(preferences.fontSize))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section("Arabic Text Color") {
                    ColorPicker("Color", selection: $preferences.arabicTextColor)

                    Text("Sample: السَّلَامُ عَلَيْكُمْ")
                        .font(.system(size: 20))
                        .foregroundColor(preferences.arabicTextColor)
                }

                Section("English Text Color") {
                    ColorPicker("Color", selection: $preferences.englishTextColor)

                    Text("Sample: Peace be upon you")
                        .font(.system(size: 18))
                        .foregroundColor(preferences.englishTextColor)
                }

                Section("Background Color") {
                    ColorPicker("Color", selection: $preferences.backgroundColor)

                    Rectangle()
                        .fill(preferences.backgroundColor)
                        .frame(height: 60)
                        .cornerRadius(8)
                        .overlay(
                            Text("Sample Background")
                                .foregroundColor(preferences.arabicTextColor)
                        )
                }

                Section {
                    Button("Reset to Defaults") {
                        preferences.reset()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Customize Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
