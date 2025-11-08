//
//  SampleQuranData.swift
//  Quran English
//
//  Created by Donald Cjapi on 7/10/25.
//

import Foundation

struct SampleQuranData {
    static func createSampleVerses() -> [QuranVerse] {
        var verses: [QuranVerse] = []

        // Al-Fatiha (Chapter 1) - Verse 1: Bismillah
        let verse1Words = [
            QuranWord(arabic: "بِسْمِ", englishTranslation: "In the name", position: 0),
            QuranWord(arabic: "اللَّهِ", englishTranslation: "of Allah", position: 1),
            QuranWord(arabic: "الرَّحْمَٰنِ", englishTranslation: "the Most Gracious", position: 2),
            QuranWord(arabic: "الرَّحِيمِ", englishTranslation: "the Most Merciful", position: 3)
        ]
        let verse1 = QuranVerse(
            surahNumber: 1,
            verseNumber: 1,
            words: verse1Words,
            fullEnglishTranslation: "In the name of Allah, the Most Gracious, the Most Merciful"
        )
        verses.append(verse1)

        // Al-Fatiha - Verse 2
        let verse2Words = [
            QuranWord(arabic: "الْحَمْدُ", englishTranslation: "All praise", position: 0),
            QuranWord(arabic: "لِلَّهِ", englishTranslation: "is for Allah", position: 1),
            QuranWord(arabic: "رَبِّ", englishTranslation: "Lord", position: 2),
            QuranWord(arabic: "الْعَالَمِينَ", englishTranslation: "of the worlds", position: 3)
        ]
        let verse2 = QuranVerse(
            surahNumber: 1,
            verseNumber: 2,
            words: verse2Words,
            fullEnglishTranslation: "All praise is for Allah—Lord of all worlds"
        )
        verses.append(verse2)

        // Al-Fatiha - Verse 3
        let verse3Words = [
            QuranWord(arabic: "الرَّحْمَٰنِ", englishTranslation: "The Most Gracious", position: 0),
            QuranWord(arabic: "الرَّحِيمِ", englishTranslation: "the Most Merciful", position: 1)
        ]
        let verse3 = QuranVerse(
            surahNumber: 1,
            verseNumber: 3,
            words: verse3Words,
            fullEnglishTranslation: "The Most Compassionate, Most Merciful"
        )
        verses.append(verse3)

        // Al-Fatiha - Verse 4
        let verse4Words = [
            QuranWord(arabic: "مَالِكِ", englishTranslation: "Master", position: 0),
            QuranWord(arabic: "يَوْمِ", englishTranslation: "of the Day", position: 1),
            QuranWord(arabic: "الدِّينِ", englishTranslation: "of Judgment", position: 2)
        ]
        let verse4 = QuranVerse(
            surahNumber: 1,
            verseNumber: 4,
            words: verse4Words,
            fullEnglishTranslation: "Master of the Day of Judgment"
        )
        verses.append(verse4)

        // Al-Fatiha - Verse 5
        let verse5Words = [
            QuranWord(arabic: "إِيَّاكَ", englishTranslation: "You alone", position: 0),
            QuranWord(arabic: "نَعْبُدُ", englishTranslation: "we worship", position: 1),
            QuranWord(arabic: "وَإِيَّاكَ", englishTranslation: "and You alone", position: 2),
            QuranWord(arabic: "نَسْتَعِينُ", englishTranslation: "we ask for help", position: 3)
        ]
        let verse5 = QuranVerse(
            surahNumber: 1,
            verseNumber: 5,
            words: verse5Words,
            fullEnglishTranslation: "You alone we worship and You alone we ask for help"
        )
        verses.append(verse5)

        // Al-Fatiha - Verse 6
        let verse6Words = [
            QuranWord(arabic: "اهْدِنَا", englishTranslation: "Guide us", position: 0),
            QuranWord(arabic: "الصِّرَاطَ", englishTranslation: "to the path", position: 1),
            QuranWord(arabic: "الْمُسْتَقِيمَ", englishTranslation: "the straight", position: 2)
        ]
        let verse6 = QuranVerse(
            surahNumber: 1,
            verseNumber: 6,
            words: verse6Words,
            fullEnglishTranslation: "Guide us along the Straight Path"
        )
        verses.append(verse6)

        // Al-Fatiha - Verse 7
        let verse7Words = [
            QuranWord(arabic: "صِرَاطَ", englishTranslation: "The path", position: 0),
            QuranWord(arabic: "الَّذِينَ", englishTranslation: "of those", position: 1),
            QuranWord(arabic: "أَنْعَمْتَ", englishTranslation: "You have blessed", position: 2),
            QuranWord(arabic: "عَلَيْهِمْ", englishTranslation: "upon them", position: 3),
            QuranWord(arabic: "غَيْرِ", englishTranslation: "not", position: 4),
            QuranWord(arabic: "الْمَغْضُوبِ", englishTranslation: "of those who earned Your anger", position: 5),
            QuranWord(arabic: "عَلَيْهِمْ", englishTranslation: "upon them", position: 6),
            QuranWord(arabic: "وَلَا", englishTranslation: "and not", position: 7),
            QuranWord(arabic: "الضَّالِّينَ", englishTranslation: "those who are astray", position: 8)
        ]
        let verse7 = QuranVerse(
            surahNumber: 1,
            verseNumber: 7,
            words: verse7Words,
            fullEnglishTranslation: "The Path of those You have blessed—not those You are displeased with, or those who are astray"
        )
        verses.append(verse7)

        return verses
    }
}
