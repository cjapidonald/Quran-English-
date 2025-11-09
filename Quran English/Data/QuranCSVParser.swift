//
//  QuranCSVParser.swift
//  Quran English
//
//  Parses the English Rwwad translation CSV file
//

import Foundation

struct QuranCSVParser {

    struct VerseData {
        let id: Int
        let surahNumber: Int
        let verseNumber: Int
        let translation: String
        let footnotes: String
    }

    /// Parses the CSV file and returns all verse data
    static func parseCSV(from filename: String) -> [VerseData] {
        print("🔍 Looking for CSV file: \(filename).csv")

        guard let filepath = Bundle.main.path(forResource: filename, ofType: "csv") else {
            print("❌ CSV file not found: \(filename).csv")
            print("📁 Bundle path: \(Bundle.main.bundlePath)")
            if let resourcePath = Bundle.main.resourcePath {
                print("📁 Resource path: \(resourcePath)")
                let files = try? FileManager.default.contentsOfDirectory(atPath: resourcePath)
                print("📄 Files in bundle: \(files?.prefix(10) ?? [])")
            }
            return []
        }

        print("✅ Found CSV at: \(filepath)")

        guard let content = try? String(contentsOfFile: filepath, encoding: .utf8) else {
            print("❌ Could not read CSV file")
            return []
        }

        print("📖 CSV file size: \(content.count) characters")
        return parseCSVContent(content)
    }

    /// Parses CSV content string handling multi-line quoted fields and escaped quotes
    static func parseCSVContent(_ content: String) -> [VerseData] {
        var verses: [VerseData] = []
        var currentRow: [String] = []
        var currentField = ""
        var insideQuotes = false
        var headerPassed = false
        var rowCount = 0

        print("🔎 Starting CSV parse...")

        let chars = Array(content)
        var i = 0
        var quoteToggles = 0

        while i < chars.count {
            let char = chars[i]

            // Handle quotes and escaped quotes ("")
            if char == "\"" {
                // Check if this is an escaped quote ("")
                if insideQuotes && i + 1 < chars.count && chars[i + 1] == "\"" {
                    // This is an escaped quote - add one quote to the field and skip both
                    currentField.append("\"")
                    i += 2
                    continue
                } else {
                    // This is a regular quote - toggle the state
                    insideQuotes.toggle()
                    quoteToggles += 1
                    if quoteToggles <= 5 {
                        print("💬 Quote toggle #\(quoteToggles) at char \(i), now insideQuotes: \(insideQuotes)")
                    }
                    i += 1
                    continue
                }
            }

            if char == "," && !insideQuotes {
                currentRow.append(currentField.trimmingCharacters(in: .whitespaces))
                currentField = ""
                i += 1
                continue
            }

            if (char == "\n" || char == "\r") && !insideQuotes {
                print("🔄 Processing newline at char \(i), currentRow has \(currentRow.count) fields")
                // Skip empty rows
                if currentField.isEmpty && currentRow.isEmpty {
                    i += 1
                    continue
                }

                currentRow.append(currentField.trimmingCharacters(in: .whitespaces))

                // Debug first few rows
                if rowCount < 5 {
                    print("📝 Row \(rowCount): \(currentRow.count) fields - [\(currentRow.prefix(3).joined(separator: ", "))]")
                    rowCount += 1
                }

                // Check if this is the header row
                if currentRow.count >= 3 && currentRow[0] == "id" && currentRow[1] == "sura" && currentRow[2] == "aya" {
                    print("📋 Found header row")
                    headerPassed = true
                    currentRow = []
                    currentField = ""
                    i += 1
                    continue
                }

                // Parse the row if header has passed
                if headerPassed && currentRow.count == 5 {
                    if let verseData = parseRow(currentRow) {
                        verses.append(verseData)
                        if verses.count == 1 {
                            print("✅ First verse parsed: Surah \(verseData.surahNumber):\(verseData.verseNumber)")
                        }
                    }
                }

                currentRow = []
                currentField = ""
                i += 1
                continue
            }

            currentField.append(char)
            i += 1
        }

        // Handle last row if needed
        if headerPassed && (!currentField.isEmpty || !currentRow.isEmpty) {
            currentRow.append(currentField.trimmingCharacters(in: .whitespaces))
            if currentRow.count == 5 {
                if let verseData = parseRow(currentRow) {
                    verses.append(verseData)
                }
            }
        }

        print("✅ Parsed \(verses.count) verses from CSV")
        return verses
    }

    /// Parses a row array into VerseData
    private static func parseRow(_ row: [String]) -> VerseData? {
        guard row.count == 5 else { return nil }

        guard let id = Int(row[0]),
              let sura = Int(row[1]),
              let aya = Int(row[2]) else {
            return nil
        }

        return VerseData(
            id: id,
            surahNumber: sura,
            verseNumber: aya,
            translation: row[3],
            footnotes: row[4]
        )
    }

}
