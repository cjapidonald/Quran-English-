//
//  SettingsView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var notes: [QuranNote]
    @State private var showExportSuccess = false
    @State private var showExportSheet = false
    @State private var csvURL: URL?

    var body: some View {
        NavigationView {
            Form {
                Section("Data Export") {
                    Button(action: exportNotesToCSV) {
                        Label("Export Notes to CSV", systemImage: "square.and.arrow.up")
                    }

                    Text("Export all your notes and categories to a CSV file")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section("Statistics") {
                    HStack {
                        Text("Total Notes")
                        Spacer()
                        Text("\(notes.count)")
                            .foregroundColor(.secondary)
                    }
                }

                Section("About") {
                    HStack {
                        Text("App Name")
                        Spacer()
                        Text("Quran English")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Support") {
                    Link(destination: URL(string: "https://github.com")!) {
                        Label("GitHub Repository", systemImage: "link")
                    }

                    Link(destination: URL(string: "mailto:support@example.com")!) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Export Successful", isPresented: $showExportSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your notes have been exported to CSV successfully.")
            }
            .sheet(isPresented: $showExportSheet) {
                if let url = csvURL {
                    ShareSheet(items: [url])
                }
            }
        }
    }

    private func exportNotesToCSV() {
        guard !notes.isEmpty else {
            return
        }

        var csvText = "Surah,Verse,Arabic Text,English Translation,Your Note,Category,Date Created,Date Updated\n"

        for note in notes.sorted(by: { $0.createdAt < $1.createdAt }) {
            let categoryName = note.category?.name ?? "Uncategorized"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short

            let arabicText = note.arabicText.replacingOccurrences(of: "\"", with: "\"\"")
            let englishTranslation = note.englishTranslation.replacingOccurrences(of: "\"", with: "\"\"")
            let userNote = note.userNote.replacingOccurrences(of: "\"", with: "\"\"")
            let category = categoryName.replacingOccurrences(of: "\"", with: "\"\"")

            let row = """
            \(note.surahNumber),\(note.verseNumber),"\(arabicText)","\(englishTranslation)","\(userNote)","\(category)","\(dateFormatter.string(from: note.createdAt))","\(dateFormatter.string(from: note.updatedAt))"
            """

            csvText.append(row)
            csvText.append("\n")
        }

        // Save to temporary directory
        let fileName = "QuranNotes_\(Date().timeIntervalSince1970).csv"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try csvText.write(to: tempURL, atomically: true, encoding: .utf8)
            csvURL = tempURL
            showExportSheet = true
        } catch {
            print("Error saving CSV: \(error)")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
