//
//  SettingsView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [QuranNote]
    @State private var preferences = UserPreferences()

    @State private var showExportSheet = false
    @State private var exportURL: URL?
    @State private var showExportSuccess = false
    @State private var showCustomization = false

    var body: some View {
        NavigationView {
            Form {
                // Appearance
                Section {
                    Button(action: { showCustomization = true }) {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .foregroundColor(UserPreferences.accentGreen)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Reading Customization")
                                    .foregroundColor(.primary)
                                Text("Fonts, colors, and theme settings")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack {
                        Image(systemName: preferences.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(preferences.isDarkMode ? UserPreferences.accentGreen : .orange)
                        Text("Current Theme")
                        Spacer()
                        Text(preferences.isDarkMode ? "Dark" : "Light")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Appearance")
                }

                // Statistics
                Section {
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.blue)
                        Text("Total Notes")
                        Spacer()
                        Text("\(notes.count)")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Statistics")
                }

                // Export
                Section {
                    Button(action: exportNotes) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Export Notes to CSV")
                                    .foregroundColor(.primary)
                                Text("Export all your notes as a CSV file")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Data")
                }

                // About
                Section {
                    HStack {
                        Text("App Name")
                        Spacer()
                        Text("Quran English")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }

                // Support
                Section {
                    Link(destination: URL(string: "https://github.com/yourusername/quran-english")!) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("GitHub Repository")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Link(destination: URL(string: "mailto:support@quran-english.com")!) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                            Text("Contact Support")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Support")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCustomization) {
                ReadingCustomizationView(preferences: preferences)
            }
            .sheet(isPresented: $showExportSheet) {
                if let url = exportURL {
                    ShareSheet(activityItems: [url])
                }
            }
            .alert("Export Successful", isPresented: $showExportSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your notes have been exported successfully.")
            }
        }
    }

    private func exportNotes() {
        guard !notes.isEmpty else {
            showExportSuccess = true
            return
        }

        // Create CSV content
        var csvText = "Surah,Verse,Arabic Text,English Translation,Your Note,Category,Date Created,Date Updated\n"

        for note in notes.sorted(by: { $0.createdAt < $1.createdAt }) {
            let categoryName = note.category?.name ?? "None"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short

            let row = [
                "\(note.surahNumber)",
                "\(note.verseNumber)",
                escapeCSV(note.arabicText),
                escapeCSV(note.englishTranslation),
                escapeCSV(note.userNote),
                escapeCSV(categoryName),
                escapeCSV(dateFormatter.string(from: note.createdAt)),
                escapeCSV(dateFormatter.string(from: note.updatedAt))
            ].joined(separator: ",")

            csvText += row + "\n"
        }

        // Save to temp directory
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "QuranNotes_\(Date().timeIntervalSince1970).csv"
        let fileURL = tempDir.appendingPathComponent(fileName)

        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            exportURL = fileURL
            showExportSheet = true
        } catch {
            print("Error exporting notes: \(error)")
        }
    }

    private func escapeCSV(_ text: String) -> String {
        // Escape quotes and wrap in quotes if contains comma, quote, or newline
        let escaped = text.replacingOccurrences(of: "\"", with: "\"\"")
        if escaped.contains(",") || escaped.contains("\"") || escaped.contains("\n") {
            return "\"\(escaped)\""
        }
        return escaped
    }
}

// Share Sheet for iOS
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
