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

                // Arabic Font Size
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Arabic Font Size")
                            Spacer()
                            Text("\(Int(preferences.arabicFontSize))pt")
                                .foregroundColor(.secondary)
                        }

                        Slider(value: $preferences.arabicFontSize, in: 18...48, step: 1)

                        // Preview text
                        if preferences.showArabic {
                            Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                                .font(.custom("Lateef", size: preferences.arabicFontSize))
                                .foregroundColor(preferences.isDarkMode ? UserPreferences.darkArabicText : .black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(preferences.backgroundColor)
                                .cornerRadius(8)
                        }
                    }
                } header: {
                    Text("Arabic Typography")
                }

                // English Font Size
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("English Font Size")
                            Spacer()
                            Text("\(Int(preferences.englishFontSize))pt")
                                .foregroundColor(.secondary)
                        }

                        Slider(value: $preferences.englishFontSize, in: 12...28, step: 1)

                        // Preview text
                        if preferences.showEnglish {
                            Text("In the name of Allah, the Most Gracious, the Most Merciful")
                                .font(.system(size: preferences.englishFontSize, weight: .regular))
                                .foregroundColor(preferences.textColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(preferences.backgroundColor)
                                .cornerRadius(8)
                        }
                    }
                } header: {
                    Text("English Typography")
                }

                // Colors
                Section {
                    ColorPicker("Text Color", selection: $preferences.textColor)
                    ColorPicker("Background Color", selection: $preferences.backgroundColor)
                } header: {
                    Text("Colors")
                } footer: {
                    Text("Customize text and background colors. Arabic text automatically adjusts for contrast.")
                }

                // Live Preview
                Section {
                    VStack(spacing: 12) {
                        Text("Full Preview")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(alignment: .leading, spacing: 16) {
                            // Verse number indicator
                            HStack {
                                Circle()
                                    .fill(UserPreferences.accentGreen.opacity(0.2))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Text("1")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(UserPreferences.accentGreen)
                                    )
                                Spacer()
                            }

                            if preferences.showArabic {
                                Text("الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ")
                                    .font(.custom("Lateef", size: preferences.arabicFontSize))
                                    .foregroundColor(preferences.isDarkMode ? UserPreferences.darkArabicText : .black)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }

                            if preferences.showEnglish {
                                Text("All praise is for Allah—Lord of all worlds")
                                    .font(.system(size: preferences.englishFontSize, weight: .regular))
                                    .foregroundColor(preferences.textColor.opacity(0.85))
                                    .lineSpacing(6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(preferences.backgroundColor)
                        .cornerRadius(12)
                    }
                } header: {
                    Text("Preview")
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
            .navigationTitle("Reading Customization")
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
