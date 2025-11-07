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

        // Al-Fatiha (Surah 1)
        let fatihaVerses = createFatihaVerses()
        let fatiha = Surah(
            surahNumber: 1,
            name: "Al-Fatiha",
            arabicName: "الفاتحة",
            revelationType: "Meccan",
            numberOfVerses: 7,
            verses: fatihaVerses
        )
        surahs.append(fatiha)

        // Al-Ikhlas (Surah 112)
        let ikhlasVerses = createIkhlasVerses()
        let ikhlas = Surah(
            surahNumber: 112,
            name: "Al-Ikhlas",
            arabicName: "الإخلاص",
            revelationType: "Meccan",
            numberOfVerses: 4,
            verses: ikhlasVerses
        )
        surahs.append(ikhlas)

        return surahs
    }

    private static func createFatihaVerses() -> [QuranVerse] {
        var verses: [QuranVerse] = []

        // Verse 1: Bismillah
        let verse1 = QuranVerse(
            surahNumber: 1,
            verseNumber: 1,
            words: [],
            fullEnglishTranslation: "In the name of Allah, the Most Gracious, the Most Merciful"
        )
        verse1.words = [
            QuranWord(arabic: "بِسْمِ", englishTranslation: "In the name", position: 0, verseId: verse1.id),
            QuranWord(arabic: "اللَّهِ", englishTranslation: "of Allah", position: 1, verseId: verse1.id),
            QuranWord(arabic: "الرَّحْمَٰنِ", englishTranslation: "the Most Gracious", position: 2, verseId: verse1.id),
            QuranWord(arabic: "الرَّحِيمِ", englishTranslation: "the Most Merciful", position: 3, verseId: verse1.id)
        ]
        verses.append(verse1)

        // Verse 2
        let verse2 = QuranVerse(
            surahNumber: 1,
            verseNumber: 2,
            words: [],
            fullEnglishTranslation: "All praise is for Allah—Lord of all worlds"
        )
        verse2.words = [
            QuranWord(arabic: "الْحَمْدُ", englishTranslation: "All praise", position: 0, verseId: verse2.id),
            QuranWord(arabic: "لِلَّهِ", englishTranslation: "is for Allah", position: 1, verseId: verse2.id),
            QuranWord(arabic: "رَبِّ", englishTranslation: "Lord", position: 2, verseId: verse2.id),
            QuranWord(arabic: "الْعَالَمِينَ", englishTranslation: "of the worlds", position: 3, verseId: verse2.id)
        ]
        verses.append(verse2)

        // Verse 3
        let verse3 = QuranVerse(
            surahNumber: 1,
            verseNumber: 3,
            words: [],
            fullEnglishTranslation: "The Most Compassionate, Most Merciful"
        )
        verse3.words = [
            QuranWord(arabic: "الرَّحْمَٰنِ", englishTranslation: "The Most Gracious", position: 0, verseId: verse3.id),
            QuranWord(arabic: "الرَّحِيمِ", englishTranslation: "the Most Merciful", position: 1, verseId: verse3.id)
        ]
        verses.append(verse3)

        // Verse 4
        let verse4 = QuranVerse(
            surahNumber: 1,
            verseNumber: 4,
            words: [],
            fullEnglishTranslation: "Master of the Day of Judgment"
        )
        verse4.words = [
            QuranWord(arabic: "مَالِكِ", englishTranslation: "Master", position: 0, verseId: verse4.id),
            QuranWord(arabic: "يَوْمِ", englishTranslation: "of the Day", position: 1, verseId: verse4.id),
            QuranWord(arabic: "الدِّينِ", englishTranslation: "of Judgment", position: 2, verseId: verse4.id)
        ]
        verses.append(verse4)

        // Verse 5
        let verse5 = QuranVerse(
            surahNumber: 1,
            verseNumber: 5,
            words: [],
            fullEnglishTranslation: "You alone we worship and You alone we ask for help"
        )
        verse5.words = [
            QuranWord(arabic: "إِيَّاكَ", englishTranslation: "You alone", position: 0, verseId: verse5.id),
            QuranWord(arabic: "نَعْبُدُ", englishTranslation: "we worship", position: 1, verseId: verse5.id),
            QuranWord(arabic: "وَإِيَّاكَ", englishTranslation: "and You alone", position: 2, verseId: verse5.id),
            QuranWord(arabic: "نَسْتَعِينُ", englishTranslation: "we ask for help", position: 3, verseId: verse5.id)
        ]
        verses.append(verse5)

        // Verse 6
        let verse6 = QuranVerse(
            surahNumber: 1,
            verseNumber: 6,
            words: [],
            fullEnglishTranslation: "Guide us along the Straight Path"
        )
        verse6.words = [
            QuranWord(arabic: "اهْدِنَا", englishTranslation: "Guide us", position: 0, verseId: verse6.id),
            QuranWord(arabic: "الصِّرَاطَ", englishTranslation: "to the path", position: 1, verseId: verse6.id),
            QuranWord(arabic: "الْمُسْتَقِيمَ", englishTranslation: "the straight", position: 2, verseId: verse6.id)
        ]
        verses.append(verse6)

        // Verse 7
        let verse7 = QuranVerse(
            surahNumber: 1,
            verseNumber: 7,
            words: [],
            fullEnglishTranslation: "The Path of those You have blessed—not those You are displeased with, or those who are astray"
        )
        verse7.words = [
            QuranWord(arabic: "صِرَاطَ", englishTranslation: "The path", position: 0, verseId: verse7.id),
            QuranWord(arabic: "الَّذِينَ", englishTranslation: "of those", position: 1, verseId: verse7.id),
            QuranWord(arabic: "أَنْعَمْتَ", englishTranslation: "You have blessed", position: 2, verseId: verse7.id),
            QuranWord(arabic: "عَلَيْهِمْ", englishTranslation: "upon them", position: 3, verseId: verse7.id),
            QuranWord(arabic: "غَيْرِ", englishTranslation: "not", position: 4, verseId: verse7.id),
            QuranWord(arabic: "الْمَغْضُوبِ", englishTranslation: "of those who earned Your anger", position: 5, verseId: verse7.id),
            QuranWord(arabic: "عَلَيْهِمْ", englishTranslation: "upon them", position: 6, verseId: verse7.id),
            QuranWord(arabic: "وَلَا", englishTranslation: "and not", position: 7, verseId: verse7.id),
            QuranWord(arabic: "الضَّالِّينَ", englishTranslation: "those who are astray", position: 8, verseId: verse7.id)
        ]
        verses.append(verse7)

        return verses
    }

    private static func createIkhlasVerses() -> [QuranVerse] {
        var verses: [QuranVerse] = []

        // Verse 1
        let verse1 = QuranVerse(
            surahNumber: 112,
            verseNumber: 1,
            words: [],
            fullEnglishTranslation: "Say, He is Allah, the One"
        )
        verse1.words = [
            QuranWord(arabic: "قُلْ", englishTranslation: "Say", position: 0, verseId: verse1.id),
            QuranWord(arabic: "هُوَ", englishTranslation: "He is", position: 1, verseId: verse1.id),
            QuranWord(arabic: "اللَّهُ", englishTranslation: "Allah", position: 2, verseId: verse1.id),
            QuranWord(arabic: "أَحَدٌ", englishTranslation: "the One", position: 3, verseId: verse1.id)
        ]
        verses.append(verse1)

        // Verse 2
        let verse2 = QuranVerse(
            surahNumber: 112,
            verseNumber: 2,
            words: [],
            fullEnglishTranslation: "Allah, the Eternal Refuge"
        )
        verse2.words = [
            QuranWord(arabic: "اللَّهُ", englishTranslation: "Allah", position: 0, verseId: verse2.id),
            QuranWord(arabic: "الصَّمَدُ", englishTranslation: "the Eternal Refuge", position: 1, verseId: verse2.id)
        ]
        verses.append(verse2)

        // Verse 3
        let verse3 = QuranVerse(
            surahNumber: 112,
            verseNumber: 3,
            words: [],
            fullEnglishTranslation: "He neither begets nor is born"
        )
        verse3.words = [
            QuranWord(arabic: "لَمْ", englishTranslation: "He has not", position: 0, verseId: verse3.id),
            QuranWord(arabic: "يَلِدْ", englishTranslation: "begotten", position: 1, verseId: verse3.id),
            QuranWord(arabic: "وَلَمْ", englishTranslation: "and not", position: 2, verseId: verse3.id),
            QuranWord(arabic: "يُولَدْ", englishTranslation: "was He begotten", position: 3, verseId: verse3.id)
        ]
        verses.append(verse3)

        // Verse 4
        let verse4 = QuranVerse(
            surahNumber: 112,
            verseNumber: 4,
            words: [],
            fullEnglishTranslation: "Nor is there to Him any equivalent"
        )
        verse4.words = [
            QuranWord(arabic: "وَلَمْ", englishTranslation: "And not", position: 0, verseId: verse4.id),
            QuranWord(arabic: "يَكُن", englishTranslation: "is", position: 1, verseId: verse4.id),
            QuranWord(arabic: "لَّهُ", englishTranslation: "to Him", position: 2, verseId: verse4.id),
            QuranWord(arabic: "كُفُوًا", englishTranslation: "equivalent", position: 3, verseId: verse4.id),
            QuranWord(arabic: "أَحَدٌ", englishTranslation: "anyone", position: 4, verseId: verse4.id)
        ]
        verses.append(verse4)

        return verses
    }
}
