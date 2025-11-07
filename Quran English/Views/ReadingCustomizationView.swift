//
//  ReadingCustomizationView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI

struct ReadingCustomizationView: View {
    @Bindable var preferences: UserPreferences
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                // Display Options
                Section("Display Options") {
                    Toggle("Show Arabic Text", isOn: $preferences.showArabic)
                    Toggle("Show English Translation", isOn: $preferences.showEnglish)
                }

                // Font Size
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Font Size")
                            Spacer()
                            Text("\(Int(preferences.fontSize))pt")
                                .foregroundColor(.secondary)
                        }

                        Slider(value: $preferences.fontSize, in: 12...32, step: 1)

                        // Preview text
                        VStack(spacing: 8) {
                            if preferences.showArabic {
                                Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                                    .font(.system(size: preferences.fontSize))
                                    .foregroundColor(preferences.arabicTextColor)
                            }

                            if preferences.showEnglish {
                                Text("In the name of Allah, the Most Gracious, the Most Merciful")
                                    .font(.system(size: preferences.fontSize * 0.85))
                                    .foregroundColor(preferences.englishTextColor)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(preferences.backgroundColor)
                        .cornerRadius(8)
                    }
                } header: {
                    Text("Font Size")
                }

                // Colors
                Section("Colors") {
                    ColorPicker("Arabic Text Color", selection: $preferences.arabicTextColor)
                    ColorPicker("English Text Color", selection: $preferences.englishTextColor)
                    ColorPicker("Background Color", selection: $preferences.backgroundColor)
                }

                // Sample Preview
                Section {
                    VStack(spacing: 12) {
                        Text("Preview")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 8) {
                            if preferences.showArabic {
                                Text("الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ")
                                    .font(.system(size: preferences.fontSize))
                                    .foregroundColor(preferences.arabicTextColor)
                            }

                            if preferences.showEnglish {
                                Text("All praise is for Allah—Lord of all worlds")
                                    .font(.system(size: preferences.fontSize * 0.85))
                                    .foregroundColor(preferences.englishTextColor)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(preferences.backgroundColor)
                        .cornerRadius(8)
                    }
                } header: {
                    Text("Live Preview")
                }

                // Reset Button
                Section {
                    Button(role: .destructive) {
                        preferences.resetToDefaults()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset to Defaults")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Customization")
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
