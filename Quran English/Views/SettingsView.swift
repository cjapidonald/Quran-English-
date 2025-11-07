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
            ZStack {
                // Dark background
                AppColors.darkBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Data Export Section
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.neonGreen)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Data Export")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(AppColors.primaryText)
                                    Text("Export all your notes and categories")
                                        .font(.system(size: 13))
                                        .foregroundColor(AppColors.secondaryText)
                                }

                                Spacer()
                            }

                            Button(action: exportNotesToCSV) {
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                    Text("Export Notes to CSV")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .vibrantButton(color: AppColors.neonGreen, fullWidth: true)
                        }
                        .glassCard(cornerRadius: 20, padding: 20)

                        // Statistics Section
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.neonCyan)

                                Text("Statistics")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)

                                Spacer()
                            }

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Total Notes")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(AppColors.secondaryText)
                                }

                                Spacer()

                                Text("\(notes.count)")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColors.neonCyan)
                                    .shadow(color: AppColors.neonCyan.opacity(0.5), radius: 4)
                            }
                        }
                        .glassCard(cornerRadius: 20, padding: 20)

                        // About Section
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.neonPurple)

                                Text("About")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)

                                Spacer()
                            }

                            VStack(spacing: 12) {
                                SettingRow(icon: "app.fill", title: "App Name", value: "Quran English", color: AppColors.neonPurple)
                                Divider().background(Color.white.opacity(0.1))
                                SettingRow(icon: "number.circle.fill", title: "Version", value: "1.0", color: AppColors.neonPurple)
                            }
                        }
                        .glassCard(cornerRadius: 20, padding: 20)

                        // Support Section
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppColors.neonPink)

                                Text("Support")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)

                                Spacer()
                            }

                            VStack(spacing: 12) {
                                Link(destination: URL(string: "https://github.com")!) {
                                    HStack {
                                        Image(systemName: "link.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(AppColors.neonPink)

                                        Text("GitHub Repository")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)

                                        Spacer()

                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                }

                                Divider().background(Color.white.opacity(0.1))

                                Link(destination: URL(string: "mailto:support@example.com")!) {
                                    HStack {
                                        Image(systemName: "envelope.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(AppColors.neonPink)

                                        Text("Contact Support")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)

                                        Spacer()

                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                }
                            }
                        }
                        .glassCard(cornerRadius: 20, padding: 20)
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
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

// MARK: - Setting Row
struct SettingRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppColors.secondaryText)

            Spacer()

            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
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
