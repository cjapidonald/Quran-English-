//
//  SampleSurahData.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation

struct SampleSurahData {
    static func createSampleSurahs() -> [Surah] {
        var surahs: [Surah] = []

        // Al-Fatiha (The Opening) - Surah 1
        let fatihaVerses = createAlFatihaVerses()
        let alFatiha = Surah(
            surahNumber: 1,
            name: "Al-Fatiha",
            arabicName: "الفاتحة",
            revelationType: "Meccan",
            numberOfVerses: 7,
            verses: fatihaVerses
        )
        surahs.append(alFatiha)

        // Al-Ikhlas (The Sincerity) - Surah 112
        let ikhlasVerses = createAlIkhlasVerses()
        let alIkhlas = Surah(
            surahNumber: 112,
            name: "Al-Ikhlas",
            arabicName: "الإخلاص",
            revelationType: "Meccan",
            numberOfVerses: 4,
            verses: ikhlasVerses
        )
        surahs.append(alIkhlas)

        return surahs
    }

    private static func createAlFatihaVerses() -> [QuranVerse] {
        var verses: [QuranVerse] = []

        // Verse 1
        let verse1ID = UUID()
        let verse1Words = [
            QuranWord(arabic: "بِسْمِ", englishTranslation: "In the name", position: 0, verseId: verse1ID),
            QuranWord(arabic: "اللَّهِ", englishTranslation: "of Allah", position: 1, verseId: verse1ID),
            QuranWord(arabic: "الرَّحْمَٰنِ", englishTranslation: "the Most Gracious", position: 2, verseId: verse1ID),
            QuranWord(arabic: "الرَّحِيمِ", englishTranslation: "the Most Merciful", position: 3, verseId: verse1ID)
        ]
        let verse1 = QuranVerse(
            surahNumber: 1,
            verseNumber: 1,
            words: verse1Words,
            fullEnglishTranslation: "In the name of Allah, the Most Gracious, the Most Merciful"
        )
        verse1.id = verse1ID
        verses.append(verse1)

        // Verse 2
        let verse2ID = UUID()
        let verse2Words = [
            QuranWord(arabic: "الْحَمْدُ", englishTranslation: "All praise", position: 0, verseId: verse2ID),
            QuranWord(arabic: "لِلَّهِ", englishTranslation: "is for Allah", position: 1, verseId: verse2ID),
            QuranWord(arabic: "رَبِّ", englishTranslation: "Lord", position: 2, verseId: verse2ID),
            QuranWord(arabic: "الْعَالَمِينَ", englishTranslation: "of the worlds", position: 3, verseId: verse2ID)
        ]
        let verse2 = QuranVerse(
            surahNumber: 1,
            verseNumber: 2,
            words: verse2Words,
            fullEnglishTranslation: "All praise is for Allah—Lord of all worlds"
        )
        verse2.id = verse2ID
        verses.append(verse2)

        // Verse 3
        let verse3ID = UUID()
        let verse3Words = [
            QuranWord(arabic: "الرَّحْمَٰنِ", englishTranslation: "The Most Gracious", position: 0, verseId: verse3ID),
            QuranWord(arabic: "الرَّحِيمِ", englishTranslation: "the Most Merciful", position: 1, verseId: verse3ID)
        ]
        let verse3 = QuranVerse(
            surahNumber: 1,
            verseNumber: 3,
            words: verse3Words,
            fullEnglishTranslation: "The Most Compassionate, Most Merciful"
        )
        verse3.id = verse3ID
        verses.append(verse3)

        // Verse 4
        let verse4ID = UUID()
        let verse4Words = [
            QuranWord(arabic: "مَالِكِ", englishTranslation: "Master", position: 0, verseId: verse4ID),
            QuranWord(arabic: "يَوْمِ", englishTranslation: "of the Day", position: 1, verseId: verse4ID),
            QuranWord(arabic: "الدِّينِ", englishTranslation: "of Judgment", position: 2, verseId: verse4ID)
        ]
        let verse4 = QuranVerse(
            surahNumber: 1,
            verseNumber: 4,
            words: verse4Words,
            fullEnglishTranslation: "Master of the Day of Judgment"
        )
        verse4.id = verse4ID
        verses.append(verse4)

        // Verse 5
        let verse5ID = UUID()
        let verse5Words = [
            QuranWord(arabic: "إِيَّاكَ", englishTranslation: "You alone", position: 0, verseId: verse5ID),
            QuranWord(arabic: "نَعْبُدُ", englishTranslation: "we worship", position: 1, verseId: verse5ID),
            QuranWord(arabic: "وَإِيَّاكَ", englishTranslation: "and You alone", position: 2, verseId: verse5ID),
            QuranWord(arabic: "نَسْتَعِينُ", englishTranslation: "we ask for help", position: 3, verseId: verse5ID)
        ]
        let verse5 = QuranVerse(
            surahNumber: 1,
            verseNumber: 5,
            words: verse5Words,
            fullEnglishTranslation: "You alone we worship and You alone we ask for help"
        )
        verse5.id = verse5ID
        verses.append(verse5)

        // Verse 6
        let verse6ID = UUID()
        let verse6Words = [
            QuranWord(arabic: "اهْدِنَا", englishTranslation: "Guide us", position: 0, verseId: verse6ID),
            QuranWord(arabic: "الصِّرَاطَ", englishTranslation: "to the path", position: 1, verseId: verse6ID),
            QuranWord(arabic: "الْمُسْتَقِيمَ", englishTranslation: "the straight", position: 2, verseId: verse6ID)
        ]
        let verse6 = QuranVerse(
            surahNumber: 1,
            verseNumber: 6,
            words: verse6Words,
            fullEnglishTranslation: "Guide us along the Straight Path"
        )
        verse6.id = verse6ID
        verses.append(verse6)

        // Verse 7
        let verse7ID = UUID()
        let verse7Words = [
            QuranWord(arabic: "صِرَاطَ", englishTranslation: "The path", position: 0, verseId: verse7ID),
            QuranWord(arabic: "الَّذِينَ", englishTranslation: "of those", position: 1, verseId: verse7ID),
            QuranWord(arabic: "أَنْعَمْتَ", englishTranslation: "You have blessed", position: 2, verseId: verse7ID),
            QuranWord(arabic: "عَلَيْهِمْ", englishTranslation: "upon them", position: 3, verseId: verse7ID),
            QuranWord(arabic: "غَيْرِ", englishTranslation: "not", position: 4, verseId: verse7ID),
            QuranWord(arabic: "الْمَغْضُوبِ", englishTranslation: "of those who earned Your anger", position: 5, verseId: verse7ID),
            QuranWord(arabic: "عَلَيْهِمْ", englishTranslation: "upon them", position: 6, verseId: verse7ID),
            QuranWord(arabic: "وَلَا", englishTranslation: "and not", position: 7, verseId: verse7ID),
            QuranWord(arabic: "الضَّالِّينَ", englishTranslation: "those who are astray", position: 8, verseId: verse7ID)
        ]
        let verse7 = QuranVerse(
            surahNumber: 1,
            verseNumber: 7,
            words: verse7Words,
            fullEnglishTranslation: "The Path of those You have blessed—not those You are displeased with, or those who are astray"
        )
        verse7.id = verse7ID
        verses.append(verse7)

        return verses
    }

    private static func createAlIkhlasVerses() -> [QuranVerse] {
        var verses: [QuranVerse] = []

        // Verse 1
        let verse1ID = UUID()
        let verse1Words = [
            QuranWord(arabic: "قُلْ", englishTranslation: "Say", position: 0, verseId: verse1ID),
            QuranWord(arabic: "هُوَ", englishTranslation: "He is", position: 1, verseId: verse1ID),
            QuranWord(arabic: "اللَّهُ", englishTranslation: "Allah", position: 2, verseId: verse1ID),
            QuranWord(arabic: "أَحَدٌ", englishTranslation: "One", position: 3, verseId: verse1ID)
        ]
        let verse1 = QuranVerse(
            surahNumber: 112,
            verseNumber: 1,
            words: verse1Words,
            fullEnglishTranslation: "Say, He is Allah, the One"
        )
        verse1.id = verse1ID
        verses.append(verse1)

        // Verse 2
        let verse2ID = UUID()
        let verse2Words = [
            QuranWord(arabic: "اللَّهُ", englishTranslation: "Allah", position: 0, verseId: verse2ID),
            QuranWord(arabic: "الصَّمَدُ", englishTranslation: "the Eternal Refuge", position: 1, verseId: verse2ID)
        ]
        let verse2 = QuranVerse(
            surahNumber: 112,
            verseNumber: 2,
            words: verse2Words,
            fullEnglishTranslation: "Allah, the Eternal Refuge"
        )
        verse2.id = verse2ID
        verses.append(verse2)

        // Verse 3
        let verse3ID = UUID()
        let verse3Words = [
            QuranWord(arabic: "لَمْ", englishTranslation: "Not", position: 0, verseId: verse3ID),
            QuranWord(arabic: "يَلِدْ", englishTranslation: "He begets", position: 1, verseId: verse3ID),
            QuranWord(arabic: "وَلَمْ", englishTranslation: "and not", position: 2, verseId: verse3ID),
            QuranWord(arabic: "يُولَدْ", englishTranslation: "He is begotten", position: 3, verseId: verse3ID)
        ]
        let verse3 = QuranVerse(
            surahNumber: 112,
            verseNumber: 3,
            words: verse3Words,
            fullEnglishTranslation: "He neither begets nor is born"
        )
        verse3.id = verse3ID
        verses.append(verse3)

        // Verse 4
        let verse4ID = UUID()
        let verse4Words = [
            QuranWord(arabic: "وَلَمْ", englishTranslation: "And not", position: 0, verseId: verse4ID),
            QuranWord(arabic: "يَكُن", englishTranslation: "is", position: 1, verseId: verse4ID),
            QuranWord(arabic: "لَّهُ", englishTranslation: "to Him", position: 2, verseId: verse4ID),
            QuranWord(arabic: "كُفُوًا", englishTranslation: "equivalent", position: 3, verseId: verse4ID),
            QuranWord(arabic: "أَحَدٌ", englishTranslation: "any one", position: 4, verseId: verse4ID)
        ]
        let verse4 = QuranVerse(
            surahNumber: 112,
            verseNumber: 4,
            words: verse4Words,
            fullEnglishTranslation: "Nor is there to Him any equivalent"
        )
        verse4.id = verse4ID
        verses.append(verse4)

        return verses
    }
}
