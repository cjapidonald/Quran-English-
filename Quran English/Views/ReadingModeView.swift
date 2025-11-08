//
//  ReadingModeView.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import SwiftUI
import SwiftData

struct ReadingModeView: View {
    let surah: Surah
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteVerse]
    @Query private var readingProgress: [ReadingProgress]
    @Query private var memorizedVerses: [MemorizedVerse]
    @Query private var verseViewProgress: [VerseViewProgress]
    @Bindable var preferences: UserPreferences

    @State private var showCustomization = false
    @State private var showChatGPT = false
    @State private var showAddNote = false
    @State private var selectedVerse: QuranVerse?
    @State private var showActionSheet = false
    @State private var showCopiedToast = false
    @State private var scrollProgress: Double = 0.0
    @State private var visibleVerses: Set<Int> = []
    @State private var selectedWord: QuranWord?
    @State private var showWordTranslation = false

    // Detect if we're in single language mode (only Arabic OR only English, not both)
    private var isSingleLanguageMode: Bool {
        (preferences.showArabic && !preferences.showEnglish) || (!preferences.showArabic && preferences.showEnglish)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                GeometryReader { scrollGeometry in
                    Color.clear.preference(key: ViewGeometryPreferenceKey.self, value: scrollGeometry.size)
                }
                .frame(height: 0)

                VStack(spacing: 24) {
                // Surah Header - Elegant book style
                VStack(spacing: 16) {
                    Text(surah.arabicName)
                        .font(.custom("Lateef", size: 42))
                        .foregroundColor(UserPreferences.darkArabicText)

                    Text(surah.name)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(preferences.textColor.opacity(0.9))

                    HStack(spacing: 8) {
                        Text(surah.revelationType)
                        Circle()
                            .fill(UserPreferences.accentGreen)
                            .frame(width: 4, height: 4)
                        Text("\(surah.numberOfVerses) verses")
                    }
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(preferences.textColor.opacity(0.5))

                    // Decorative divider
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    UserPreferences.accentGreen.opacity(0.3),
                                    Color.clear
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                        .frame(maxWidth: 200)
                        .padding(.top, 8)
                }
                .padding(.top, 32)
                .padding(.bottom, 32)

                // Choose layout based on language display mode
                if isSingleLanguageMode {
                    // Fluid, continuous text for single language
                    FluidReadingView(
                        verses: (surah.verses ?? []).sorted(by: { $0.verseNumber < $1.verseNumber }),
                        preferences: preferences,
                        selectedWord: $selectedWord,
                        showTranslation: $showWordTranslation,
                        onVerseTap: { verse in
                            selectedVerse = verse
                            showActionSheet = true
                        },
                        onVerseAppear: markVerseAsViewed,
                        isFavorited: isFavorited,
                        isMemorized: isMemorized
                    )
                    .padding(.horizontal, 24)
                } else {
                    // Traditional verse-by-verse for dual language
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach((surah.verses ?? []).sorted(by: { $0.verseNumber < $1.verseNumber })) { verse in
                            BookStyleVerseView(
                                verse: verse,
                                preferences: preferences,
                                isFavorited: isFavorited(verse),
                                isMemorized: isMemorized(verse),
                                selectedWord: $selectedWord,
                                showTranslation: $showWordTranslation,
                                onDoubleTap: { toggleFavorite(verse) },
                                onLongPress: {
                                    selectedVerse = verse
                                    showActionSheet = true
                                }
                            )
                            .id(verse.verseNumber)
                            .onAppear {
                                markVerseAsViewed(verse)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 16)
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.preference(key: ContentHeightPreferenceKey.self, value: contentGeometry.size.height)
                }
            )
            }
            .coordinateSpace(name: "scroll")
        }
        .background(preferences.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationTitle(surah.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Calculate progress based on viewed verses
            updateScrollProgress()
        }
        .onDisappear {
            saveProgress()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    // Language display toggle
                    Menu {
                        Button(action: {
                            preferences.showArabic = true
                            preferences.showEnglish = true
                        }) {
                            HStack {
                                Text("Both")
                                if preferences.showArabic && preferences.showEnglish {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }

                        Button(action: {
                            preferences.showArabic = true
                            preferences.showEnglish = false
                        }) {
                            HStack {
                                Text("Arabic Only")
                                if preferences.showArabic && !preferences.showEnglish {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }

                        Button(action: {
                            preferences.showArabic = false
                            preferences.showEnglish = true
                        }) {
                            HStack {
                                Text("English Only")
                                if !preferences.showArabic && preferences.showEnglish {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "text.bubble")
                            .foregroundColor(UserPreferences.accentGreen)
                    }

                    // Mark as read button
                    Button(action: markAsFullyRead) {
                        Image(systemName: scrollProgress >= 100 ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(scrollProgress >= 100 ? UserPreferences.accentGreen : .gray)
                    }

                    // Customization button
                    Button(action: { showCustomization = true }) {
                        Image(systemName: "textformat.size")
                            .foregroundColor(UserPreferences.accentGreen)
                    }
                }
            }
        }
        .sheet(isPresented: $showCustomization) {
            ReadingCustomizationView(preferences: preferences)
        }
        .sheet(isPresented: $showChatGPT) {
            if let verse = selectedVerse {
                ChatGPTView(verse: verse)
            }
        }
        .sheet(isPresented: $showAddNote) {
            if let verse = selectedVerse {
                AddNoteView(verse: verse)
            }
        }
        .confirmationDialog("Verse Actions", isPresented: $showActionSheet, presenting: selectedVerse) { verse in
            Button("Ask ChatGPT") {
                showChatGPT = true
            }

            Button("Add to Notes") {
                showAddNote = true
            }

            Button("Copy Verse") {
                copyVerse(verse)
            }

            Button(isFavorited(verse) ? "Remove from Favorites" : "Add to Favorites") {
                toggleFavorite(verse)
            }

            Button(isMemorized(verse) ? "Remove from Memorized" : "Mark as Memorized") {
                toggleMemorization(verse)
            }

            Button("Cancel", role: .cancel) {}
        } message: { verse in
            Text("Surah \(verse.surahNumber):\(verse.verseNumber)")
        }
        .overlay(alignment: .bottom) {
            if showCopiedToast {
                copiedToastView
            }
        }
        .overlay {
            if showWordTranslation, let word = selectedWord {
                wordTranslationOverlay(for: word)
            }
        }
    }

    @ViewBuilder
    private var copiedToastView: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            Text("Verse copied to clipboard")
        }
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding(.bottom, 50)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    @ViewBuilder
    private func wordTranslationOverlay(for word: QuranWord) -> some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    showWordTranslation = false
                    selectedWord = nil
                }

            WordTranslationPopup(
                word: word,
                surahNumber: surah.surahNumber,
                surahName: surah.name,
                verseNumber: getVerseNumberForWord(word),
                onDismiss: {
                    showWordTranslation = false
                    selectedWord = nil
                }
            )
        }
    }

    // Helper to find verse number from word
    private func getVerseNumberForWord(_ word: QuranWord) -> Int {
        if let verse = (surah.verses ?? []).first(where: { verse in
            (verse.words ?? []).contains(where: { $0.position == word.position })
        }) {
            return verse.verseNumber
        }
        return 1 // Fallback
    }

    private func isFavorited(_ verse: QuranVerse) -> Bool {
        favorites.contains { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }
    }

    private func toggleFavorite(_ verse: QuranVerse) {
        if let existing = favorites.first(where: { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }) {
            modelContext.delete(existing)
        } else {
            let favorite = FavoriteVerse(
                surahNumber: verse.surahNumber,
                verseNumber: verse.verseNumber,
                arabicText: verse.fullArabicText,
                englishTranslation: verse.fullEnglishTranslation
            )
            modelContext.insert(favorite)
        }
        try? modelContext.save()
    }

    private func copyVerse(_ verse: QuranVerse) {
        let text = """
        Quran \(verse.surahNumber):\(verse.verseNumber)

        \(verse.fullArabicText)

        \(verse.fullEnglishTranslation)
        """

        UIPasteboard.general.string = text

        withAnimation {
            showCopiedToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopiedToast = false
            }
        }
    }

    private func markVerseAsViewed(_ verse: QuranVerse) {
        // Check if this verse has already been marked as viewed
        let existing = verseViewProgress.first(where: {
            $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber
        })

        if existing == nil {
            // Create new view progress record
            let viewProgress = VerseViewProgress(
                surahNumber: verse.surahNumber,
                verseNumber: verse.verseNumber,
                hasBeenViewed: true
            )
            modelContext.insert(viewProgress)
            try? modelContext.save()

            // Recalculate overall progress
            updateScrollProgress()
        }
    }

    private func updateScrollProgress() {
        // Calculate progress based on verses actually viewed
        let totalVerses = surah.numberOfVerses
        guard totalVerses > 0 else { return }

        // Count how many verses of this surah have been viewed
        let viewedCount = verseViewProgress.filter {
            $0.surahNumber == surah.surahNumber && $0.hasBeenViewed
        }.count

        // Calculate percentage
        let newProgress = (Double(viewedCount) / Double(totalVerses)) * 100.0
        scrollProgress = min(newProgress, 100.0)

        // Save progress
        saveProgress()
    }

    private func markAsFullyRead() {
        // Mark all verses as viewed
        for verse in (surah.verses ?? []) {
            let existing = verseViewProgress.first(where: {
                $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber
            })

            if existing == nil {
                let viewProgress = VerseViewProgress(
                    surahNumber: verse.surahNumber,
                    verseNumber: verse.verseNumber,
                    hasBeenViewed: true
                )
                modelContext.insert(viewProgress)
            }
        }
        try? modelContext.save()

        scrollProgress = 100.0
        saveProgress()
    }

    private func loadProgress() {
        if let existing = readingProgress.first(where: { $0.surahNumber == surah.surahNumber }) {
            scrollProgress = existing.progressPercentage
        }
    }

    private func saveProgress() {
        if let existing = readingProgress.first(where: { $0.surahNumber == surah.surahNumber }) {
            existing.progressPercentage = scrollProgress
            existing.lastReadAt = Date()
        } else {
            let newProgress = ReadingProgress(
                surahNumber: surah.surahNumber,
                surahName: surah.name,
                progressPercentage: scrollProgress
            )
            modelContext.insert(newProgress)
        }
        try? modelContext.save()
    }

    private func isMemorized(_ verse: QuranVerse) -> Bool {
        memorizedVerses.contains { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }
    }

    private func toggleMemorization(_ verse: QuranVerse) {
        if let existing = memorizedVerses.first(where: { $0.surahNumber == verse.surahNumber && $0.verseNumber == verse.verseNumber }) {
            modelContext.delete(existing)
        } else {
            let memorized = MemorizedVerse(
                surahNumber: verse.surahNumber,
                verseNumber: verse.verseNumber,
                arabicText: verse.fullArabicText
            )
            modelContext.insert(memorized)
        }
        try? modelContext.save()
    }
}

// Preference Keys
struct ViewGeometryPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Fluid Reading View (Single Language)
struct FluidReadingView: View {
    let verses: [QuranVerse]
    let preferences: UserPreferences
    @Binding var selectedWord: QuranWord?
    @Binding var showTranslation: Bool
    let onVerseTap: (QuranVerse) -> Void
    let onVerseAppear: (QuranVerse) -> Void
    let isFavorited: (QuranVerse) -> Bool
    let isMemorized: (QuranVerse) -> Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if preferences.showArabic && !preferences.showEnglish {
                // Arabic-only fluid reading
                arabicFluidText
            } else if !preferences.showArabic && preferences.showEnglish {
                // English-only fluid reading
                englishFluidText
            }
        }
    }

    // Fluid Arabic text with inline verse numbers
    @ViewBuilder
    private var arabicFluidText: some View {
        FlowLayout(spacing: 6) {
            ForEach(verses) { verse in
                ForEach(Array((verse.words ?? []).enumerated()), id: \.element.position) { index, word in
                    TappableWordView(
                        word: word,
                        verse: verse,
                        onTap: { tappedWord in
                            selectedWord = tappedWord
                            showTranslation = true
                        },
                        onLongPress: { longPressedVerse in
                            onVerseTap(longPressedVerse)
                        }
                    )
                }

                // Inline verse number with icons (similar to English brackets)
                inlineArabicVerseIndicator(verse)
                    .padding(.horizontal, 4)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 8)
    }

    // Inline Arabic verse indicator with number and icons
    @ViewBuilder
    private func inlineArabicVerseIndicator(_ verse: QuranVerse) -> some View {
        let indicatorColor = preferences.isDarkMode ? Color.white.opacity(0.3) : Color.black.opacity(0.3)

        HStack(spacing: 1) {
            // Closing bracket (RTL - appears on right side)
            Text("]")
                .font(.system(size: preferences.arabicFontSize * 0.5, weight: .regular))
                .foregroundColor(indicatorColor)

            // Brain if memorized
            if isMemorized(verse) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: preferences.arabicFontSize * 0.35))
                    .foregroundColor(indicatorColor)
            }

            // Heart if favorited
            if isFavorited(verse) {
                Image(systemName: "heart.fill")
                    .font(.system(size: preferences.arabicFontSize * 0.35))
                    .foregroundColor(indicatorColor)
            }

            // Verse number
            Text("\(verse.verseNumber)")
                .font(.system(size: preferences.arabicFontSize * 0.5, weight: .semibold))
                .foregroundColor(indicatorColor)

            // Opening bracket (RTL - appears on left side)
            Text("[")
                .font(.system(size: preferences.arabicFontSize * 0.5, weight: .regular))
                .foregroundColor(indicatorColor)
        }
        .onAppear {
            onVerseAppear(verse)
        }
        .onTapGesture {
            onVerseTap(verse)
        }
    }

    // Fluid English text with inline verse numbers and long-press support
    @ViewBuilder
    private var englishFluidText: some View {
        FlowLayout(spacing: 4) {
            ForEach(verses) { verse in
                // Split verse into words
                let words = verse.fullEnglishTranslation.components(separatedBy: " ")

                ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                    Text(word)
                        .font(.system(size: preferences.englishFontSize, weight: .regular))
                        .foregroundColor(preferences.textColor.opacity(0.9))
                        .onLongPressGesture {
                            onVerseTap(verse)
                        }
                }

                // Inline verse number with icons
                inlineEnglishVerseIndicator(verse)
                    .padding(.horizontal, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }

    // Inline English verse indicator with number and icons
    @ViewBuilder
    private func inlineEnglishVerseIndicator(_ verse: QuranVerse) -> some View {
        let indicatorColor = preferences.isDarkMode ? Color.white.opacity(0.3) : Color.black.opacity(0.3)

        HStack(spacing: 2) {
            // Opening bracket
            Text("[")
                .font(.system(size: preferences.englishFontSize - 2, weight: .regular))
                .foregroundColor(indicatorColor)

            // Verse number
            Text("\(verse.verseNumber)")
                .font(.system(size: preferences.englishFontSize - 2, weight: .semibold))
                .foregroundColor(indicatorColor)

            // Heart if favorited
            if isFavorited(verse) {
                Image(systemName: "heart.fill")
                    .font(.system(size: preferences.englishFontSize * 0.6))
                    .foregroundColor(indicatorColor)
            }

            // Brain if memorized
            if isMemorized(verse) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: preferences.englishFontSize * 0.6))
                    .foregroundColor(indicatorColor)
            }

            // Closing bracket
            Text("]")
                .font(.system(size: preferences.englishFontSize - 2, weight: .regular))
                .foregroundColor(indicatorColor)
        }
        .onAppear {
            onVerseAppear(verse)
        }
        .onTapGesture {
            onVerseTap(verse)
        }
    }

    // Verse number badge
    @ViewBuilder
    private func verseNumberBadge(_ number: Int, verse: QuranVerse) -> some View {
        HStack(spacing: 3) {
            // Verse number in a circle
            ZStack {
                Circle()
                    .fill(UserPreferences.accentGreen.opacity(0.15))
                    .frame(width: 28, height: 28)

                Text("\(number)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(UserPreferences.accentGreen)
            }

            // Subtle indicators for favorite/memorized
            if isFavorited(verse) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 8))
                    .foregroundColor(UserPreferences.accentGreen.opacity(0.6))
            }

            if isMemorized(verse) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 8))
                    .foregroundColor(Color(red: 0.0, green: 0.78, blue: 0.75).opacity(0.6))
            }
        }
        .padding(.horizontal, 2)
        .onAppear {
            onVerseAppear(verse)
        }
        .onTapGesture {
            onVerseTap(verse)
        }
    }
}

// MARK: - Book Style Verse View (Dual Language)
// Book-style verse view - continuous flowing text like a traditional book
struct BookStyleVerseView: View {
    let verse: QuranVerse
    let preferences: UserPreferences
    let isFavorited: Bool
    let isMemorized: Bool
    @Binding var selectedWord: QuranWord?
    @Binding var showTranslation: Bool
    let onDoubleTap: () -> Void
    let onLongPress: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Verse number in margin (book-style)
            VStack(spacing: 4) {
                Text("\(verse.verseNumber)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(UserPreferences.accentGreen.opacity(0.7))
                    .frame(width: 32)

                // Status indicators (subtle, in margin)
                if isFavorited {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                        .foregroundColor(UserPreferences.accentGreen.opacity(0.5))
                }

                if isMemorized {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.0, green: 0.78, blue: 0.75).opacity(0.5))
                }
            }
            .frame(width: 32)
            .padding(.top, 4)

            // Verse content - flowing like book text
            VStack(alignment: .leading, spacing: 16) {
                // Arabic text - continuous flow
                if preferences.showArabic {
                    FlowLayout(spacing: 6) {
                        ForEach(Array((verse.words ?? []).enumerated()), id: \.element.position) { index, word in
                            TappableWordView(
                                word: word,
                                verse: verse,
                                onTap: { tappedWord in
                                    selectedWord = tappedWord
                                    showTranslation = true
                                },
                                onLongPress: { longPressedVerse in
                                    onLongPress()
                                }
                            )
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                }

                // English translation - book paragraph style
                if preferences.showEnglish {
                    Text(verse.fullEnglishTranslation)
                        .font(.system(size: preferences.englishFontSize, weight: .regular))
                        .foregroundColor(preferences.textColor.opacity(0.8))
                        .lineSpacing(7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onLongPressGesture {
                            onLongPress()
                        }
                }
            }
            .padding(.bottom, 20) // Spacing between verses, like paragraphs
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            onDoubleTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}

// Legacy VerseCardView - kept for compatibility with other views
struct VerseCardView: View {
    let verse: QuranVerse
    let preferences: UserPreferences
    let isFavorited: Bool
    let isMemorized: Bool
    let onDoubleTap: () -> Void
    let onLongPress: () -> Void

    @State private var selectedWord: QuranWord?
    @State private var showTranslation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Verse number indicator (minimal, Apple Fitness style)
            HStack(spacing: 8) {
                Circle()
                    .fill(UserPreferences.accentGreen.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("\(verse.verseNumber)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(UserPreferences.accentGreen)
                    )

                if isFavorited {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14))
                        .foregroundColor(UserPreferences.accentGreen)
                }

                if isMemorized {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.0, green: 0.78, blue: 0.75))
                }

                Spacer()
            }

            // Arabic text with tappable words - NO BOX
            if preferences.showArabic {
                FlowLayout(spacing: 6) {
                    ForEach(Array((verse.words ?? []).enumerated()), id: \.element.position) { index, word in
                        TappableWordView(word: word) { tappedWord in
                            selectedWord = tappedWord
                            showTranslation = true
                        }
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                .padding(.vertical, 8)
            }

            // Full English translation - NO BOX, seamless
            if preferences.showEnglish {
                Text(verse.fullEnglishTranslation)
                    .font(.system(size: preferences.englishFontSize, weight: .regular))
                    .foregroundColor(preferences.textColor.opacity(0.85))
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            onDoubleTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
        .overlay(
            Group {
                if showTranslation, let word = selectedWord {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showTranslation = false
                            selectedWord = nil
                        }

                    WordTranslationPopup(
                        word: word,
                        surahNumber: verse.surahNumber,
                        surahName: "",
                        verseNumber: verse.verseNumber,
                        onDismiss: {
                            showTranslation = false
                            selectedWord = nil
                        }
                    )
                }
            }
        )
    }
}
