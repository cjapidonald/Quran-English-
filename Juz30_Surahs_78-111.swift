//
//  Juz30_Surahs_78-111.swift
//  Quran English
//
//  Extension to ComprehensiveQuranData.swift
//  Contains complete Quran data for Juz 30 (Surahs 78-111) with Rwwad translation
//  Word-by-word translations from Quran.com API
//

import Foundation

extension ComprehensiveQuranData {

    // MARK: - Juz 30 Surahs (78-111)

    static func createJuz30Surahs() -> [Surah] {
        var surahs: [Surah] = []

        surahs.append(createSurah78())  // An-Naba
        surahs.append(createSurah79())  // An-Nazi'at
        surahs.append(createSurah80())  // Abasa
        surahs.append(createSurah81())  // At-Takwir
        surahs.append(createSurah82())  // Al-Infitar
        surahs.append(createSurah83())  // Al-Mutaffifin
        surahs.append(createSurah84())  // Al-Inshiqaq
        surahs.append(createSurah85())  // Al-Buruj
        surahs.append(createSurah86())  // At-Tariq
        surahs.append(createSurah87())  // Al-A'la
        surahs.append(createSurah88())  // Al-Ghashiyah
        surahs.append(createSurah89())  // Al-Fajr
        surahs.append(createSurah90())  // Al-Balad
        surahs.append(createSurah91())  // Ash-Shams
        surahs.append(createSurah92())  // Al-Layl
        surahs.append(createSurah93())  // Ad-Duhaa
        surahs.append(createSurah94())  // Ash-Sharh
        surahs.append(createSurah95())  // At-Tin
        surahs.append(createSurah96())  // Al-Alaq
        surahs.append(createSurah97())  // Al-Qadr
        surahs.append(createSurah98())  // Al-Bayyinah
        surahs.append(createSurah99())  // Az-Zalzalah
        surahs.append(createSurah100()) // Al-Adiyat
        surahs.append(createSurah101()) // Al-Qari'ah
        surahs.append(createSurah102()) // At-Takathur
        surahs.append(createSurah103()) // Al-Asr
        surahs.append(createSurah104()) // Al-Humazah
        surahs.append(createSurah105()) // Al-Fil
        surahs.append(createSurah106()) // Quraysh
        surahs.append(createSurah107()) // Al-Ma'un
        surahs.append(createSurah108()) // Al-Kawthar
        surahs.append(createSurah109()) // Al-Kafirun
        surahs.append(createSurah110()) // An-Nasr
        surahs.append(createSurah111()) // Al-Masad

        return surahs
    }

    // MARK: - Surah 103: Al-Asr (The Time)
    private static func createSurah103() -> Surah {
        var verses: [QuranVerse] = []

        // Verse 1
        let v1 = QuranVerse(surahNumber: 103, verseNumber: 1, words: [], fullEnglishTranslation: "By the time")
        v1.words = [
            QuranWord(arabic: "وَٱلْعَصْرِ", englishTranslation: "By the time", position: 0)
        ]
        verses.append(v1)

        // Verse 2
        let v2 = QuranVerse(surahNumber: 103, verseNumber: 2, words: [], fullEnglishTranslation: "Man is in utter loss")
        v2.words = [
            QuranWord(arabic: "إِنَّ", englishTranslation: "Indeed", position: 0),
            QuranWord(arabic: "ٱلْإِنسَـٰنَ", englishTranslation: "mankind", position: 1),
            QuranWord(arabic: "لَفِى", englishTranslation: "(is) surely, in", position: 2),
            QuranWord(arabic: "خُسْرٍ", englishTranslation: "loss", position: 3)
        ]
        verses.append(v2)

        // Verse 3
        let v3 = QuranVerse(surahNumber: 103, verseNumber: 3, words: [], fullEnglishTranslation: "Except those who believe and do righteous deeds, and exhort one another to the truth and exhort one another to patience")
        v3.words = [
            QuranWord(arabic: "إِلَّا", englishTranslation: "Except", position: 0),
            QuranWord(arabic: "ٱلَّذِينَ", englishTranslation: "those who", position: 1),
            QuranWord(arabic: "ءَامَنُوا۟", englishTranslation: "believe", position: 2),
            QuranWord(arabic: "وَعَمِلُوا۟", englishTranslation: "and do", position: 3),
            QuranWord(arabic: "ٱلصَّـٰلِحَـٰتِ", englishTranslation: "righteous deeds", position: 4),
            QuranWord(arabic: "وَتَوَاصَوْا۟", englishTranslation: "and enjoin each other", position: 5),
            QuranWord(arabic: "بِٱلْحَقِّ", englishTranslation: "to the truth", position: 6),
            QuranWord(arabic: "وَتَوَاصَوْا۟", englishTranslation: "and enjoin each other", position: 7),
            QuranWord(arabic: "بِٱلصَّبْرِ", englishTranslation: "to patience", position: 8)
        ]
        verses.append(v3)

        return Surah(surahNumber: 103, name: "Al-Asr", arabicName: "العصر", revelationType: "Meccan", numberOfVerses: 3, verses: verses)
    }

    // MARK: - Surah 108: Al-Kawthar (The Abundance)
    private static func createSurah108() -> Surah {
        var verses: [QuranVerse] = []

        // Verse 1
        let v1 = QuranVerse(surahNumber: 108, verseNumber: 1, words: [], fullEnglishTranslation: "We have surely given you O Prophet al-Kauthar, i.e., abundance")
        v1.words = [
            QuranWord(arabic: "إِنَّآ", englishTranslation: "Indeed, We", position: 0),
            QuranWord(arabic: "أَعْطَيْنَـٰكَ", englishTranslation: "We have given you", position: 1),
            QuranWord(arabic: "ٱلْكَوْثَرَ", englishTranslation: "Al-Kauthar", position: 2)
        ]
        verses.append(v1)

        // Verse 2
        let v2 = QuranVerse(surahNumber: 108, verseNumber: 2, words: [], fullEnglishTranslation: "so pray and offer sacrifice to your Lord alone")
        v2.words = [
            QuranWord(arabic: "فَصَلِّ", englishTranslation: "So pray", position: 0),
            QuranWord(arabic: "لِرَبِّكَ", englishTranslation: "to your Lord", position: 1),
            QuranWord(arabic: "وَٱنْحَرْ", englishTranslation: "and sacrifice", position: 2)
        ]
        verses.append(v2)

        // Verse 3
        let v3 = QuranVerse(surahNumber: 108, verseNumber: 3, words: [], fullEnglishTranslation: "Indeed, the one who hates you is truly cut off from all goodness")
        v3.words = [
            QuranWord(arabic: "إِنَّ", englishTranslation: "Indeed", position: 0),
            QuranWord(arabic: "شَانِئَكَ", englishTranslation: "your enemy", position: 1),
            QuranWord(arabic: "هُوَ", englishTranslation: "he (is)", position: 2),
            QuranWord(arabic: "ٱلْأَبْتَرُ", englishTranslation: "the one cut off", position: 3)
        ]
        verses.append(v3)

        return Surah(surahNumber: 108, name: "Al-Kawthar", arabicName: "الكوثر", revelationType: "Meccan", numberOfVerses: 3, verses: verses)
    }

    // MARK: - Surah 110: An-Nasr (The Help)
    private static func createSurah110() -> Surah {
        var verses: [QuranVerse] = []

        // Verse 1
        let v1 = QuranVerse(surahNumber: 110, verseNumber: 1, words: [], fullEnglishTranslation: "When there comes Allah's help and the conquest")
        v1.words = [
            QuranWord(arabic: "إِذَا", englishTranslation: "When", position: 0),
            QuranWord(arabic: "جَآءَ", englishTranslation: "comes", position: 1),
            QuranWord(arabic: "نَصْرُ", englishTranslation: "(the) Help", position: 2),
            QuranWord(arabic: "ٱللَّهِ", englishTranslation: "(of) Allah", position: 3),
            QuranWord(arabic: "وَٱلْفَتْحُ", englishTranslation: "and the Victory", position: 4)
        ]
        verses.append(v1)

        // Verse 2
        let v2 = QuranVerse(surahNumber: 110, verseNumber: 2, words: [], fullEnglishTranslation: "and you see people entering Allah's religion in multitudes")
        v2.words = [
            QuranWord(arabic: "وَرَأَيْتَ", englishTranslation: "And you see", position: 0),
            QuranWord(arabic: "ٱلنَّاسَ", englishTranslation: "the people", position: 1),
            QuranWord(arabic: "يَدْخُلُونَ", englishTranslation: "entering", position: 2),
            QuranWord(arabic: "فِى", englishTranslation: "into", position: 3),
            QuranWord(arabic: "دِينِ", englishTranslation: "(the) religion", position: 4),
            QuranWord(arabic: "ٱللَّهِ", englishTranslation: "(of) Allah", position: 5),
            QuranWord(arabic: "أَفْوَاجًۭا", englishTranslation: "(in) multitudes", position: 6)
        ]
        verses.append(v2)

        // Verse 3
        let v3 = QuranVerse(surahNumber: 110, verseNumber: 3, words: [], fullEnglishTranslation: "then glorify the praise of your Lord, and ask His forgiveness. Indeed, He is ever Accepting of Repentance.")
        v3.words = [
            QuranWord(arabic: "فَسَبِّحْ", englishTranslation: "Then glorify", position: 0),
            QuranWord(arabic: "بِحَمْدِ", englishTranslation: "with (the) praises", position: 1),
            QuranWord(arabic: "رَبِّكَ", englishTranslation: "(of) your Lord", position: 2),
            QuranWord(arabic: "وَٱسْتَغْفِرْهُ", englishTranslation: "and ask His forgiveness", position: 3),
            QuranWord(arabic: "إِنَّهُۥ", englishTranslation: "Indeed, He", position: 4),
            QuranWord(arabic: "كَانَ", englishTranslation: "is", position: 5),
            QuranWord(arabic: "تَوَّابًۢا", englishTranslation: "Oft-Returning", position: 6)
        ]
        verses.append(v3)

        return Surah(surahNumber: 110, name: "An-Nasr", arabicName: "النصر", revelationType: "Medinan", numberOfVerses: 3, verses: verses)
    }

    // MARK: - Surah 106: Quraysh
    private static func createSurah106() -> Surah {
        var verses: [QuranVerse] = []

        // Verse 1
        let v1 = QuranVerse(surahNumber: 106, verseNumber: 1, words: [], fullEnglishTranslation: "For the accustomed security of the Quraysh")
        v1.words = [
            QuranWord(arabic: "لِإِيلَـٰفِ", englishTranslation: "For (the) familiarity", position: 0),
            QuranWord(arabic: "قُرَيْشٍ", englishTranslation: "(of the) Quraish", position: 1)
        ]
        verses.append(v1)

        // Verse 2
        let v2 = QuranVerse(surahNumber: 106, verseNumber: 2, words: [], fullEnglishTranslation: "secure in their winter and summer journeys")
        v2.words = [
            QuranWord(arabic: "إِۦلَـٰفِهِمْ", englishTranslation: "Their familiarity", position: 0),
            QuranWord(arabic: "رِحْلَةَ", englishTranslation: "(with the) journey", position: 1),
            QuranWord(arabic: "ٱلشِّتَآءِ", englishTranslation: "(of) winter", position: 2),
            QuranWord(arabic: "وَٱلصَّيْفِ", englishTranslation: "and summer", position: 3)
        ]
        verses.append(v2)

        // Verse 3
        let v3 = QuranVerse(surahNumber: 106, verseNumber: 3, words: [], fullEnglishTranslation: "Let them worship the Lord of this Sacred House")
        v3.words = [
            QuranWord(arabic: "فَلْيَعْبُدُوا۟", englishTranslation: "So let them worship", position: 0),
            QuranWord(arabic: "رَبَّ", englishTranslation: "(the) Lord", position: 1),
            QuranWord(arabic: "هَـٰذَا", englishTranslation: "(of) this", position: 2),
            QuranWord(arabic: "ٱلْبَيْتِ", englishTranslation: "House", position: 3)
        ]
        verses.append(v3)

        // Verse 4
        let v4 = QuranVerse(surahNumber: 106, verseNumber: 4, words: [], fullEnglishTranslation: "Who fed them against hunger and made them secure against fear")
        v4.words = [
            QuranWord(arabic: "ٱلَّذِىٓ", englishTranslation: "The One Who", position: 0),
            QuranWord(arabic: "أَطْعَمَهُم", englishTranslation: "feeds them", position: 1),
            QuranWord(arabic: "مِّن", englishTranslation: "from", position: 2),
            QuranWord(arabic: "جُوعٍۢ", englishTranslation: "hunger", position: 3),
            QuranWord(arabic: "وَءَامَنَهُم", englishTranslation: "gives them security", position: 4),
            QuranWord(arabic: "مِّنْ", englishTranslation: "from", position: 5),
            QuranWord(arabic: "خَوْفٍۭ", englishTranslation: "fear", position: 6)
        ]
        verses.append(v4)

        return Surah(surahNumber: 106, name: "Quraysh", arabicName: "قريش", revelationType: "Meccan", numberOfVerses: 4, verses: verses)
    }

    // MARK: - Placeholder functions for remaining surahs
    // NOTE: These need to be filled in with complete word-by-word data
    // The format follows the same pattern as the surahs above

    private static func createSurah78() -> Surah {
        // An-Naba - 40 verses
        // TODO: Add complete implementation with word-by-word data
        return Surah(surahNumber: 78, name: "An-Naba", arabicName: "النبإ", revelationType: "Meccan", numberOfVerses: 40, verses: [])
    }

    private static func createSurah79() -> Surah {
        // An-Nazi'at - 46 verses
        return Surah(surahNumber: 79, name: "An-Nazi'at", arabicName: "النازعات", revelationType: "Meccan", numberOfVerses: 46, verses: [])
    }

    private static func createSurah80() -> Surah {
        // Abasa - 42 verses
        return Surah(surahNumber: 80, name: "Abasa", arabicName: "عبس", revelationType: "Meccan", numberOfVerses: 42, verses: [])
    }

    private static func createSurah81() -> Surah {
        // At-Takwir - 29 verses
        return Surah(surahNumber: 81, name: "At-Takwir", arabicName: "التكوير", revelationType: "Meccan", numberOfVerses: 29, verses: [])
    }

    private static func createSurah82() -> Surah {
        // Al-Infitar - 19 verses
        return Surah(surahNumber: 82, name: "Al-Infitar", arabicName: "الإنفطار", revelationType: "Meccan", numberOfVerses: 19, verses: [])
    }

    private static func createSurah83() -> Surah {
        // Al-Mutaffifin - 36 verses
        return Surah(surahNumber: 83, name: "Al-Mutaffifin", arabicName: "المطففين", revelationType: "Meccan", numberOfVerses: 36, verses: [])
    }

    private static func createSurah84() -> Surah {
        // Al-Inshiqaq - 25 verses
        return Surah(surahNumber: 84, name: "Al-Inshiqaq", arabicName: "الإنشقاق", revelationType: "Meccan", numberOfVerses: 25, verses: [])
    }

    private static func createSurah85() -> Surah {
        // Al-Buruj - 22 verses
        return Surah(surahNumber: 85, name: "Al-Buruj", arabicName: "البروج", revelationType: "Meccan", numberOfVerses: 22, verses: [])
    }

    private static func createSurah86() -> Surah {
        // At-Tariq - 17 verses
        return Surah(surahNumber: 86, name: "At-Tariq", arabicName: "الطارق", revelationType: "Meccan", numberOfVerses: 17, verses: [])
    }

    private static func createSurah87() -> Surah {
        // Al-A'la - 19 verses
        return Surah(surahNumber: 87, name: "Al-A'la", arabicName: "الأعلى", revelationType: "Meccan", numberOfVerses: 19, verses: [])
    }

    private static func createSurah88() -> Surah {
        // Al-Ghashiyah - 26 verses
        return Surah(surahNumber: 88, name: "Al-Ghashiyah", arabicName: "الغاشية", revelationType: "Meccan", numberOfVerses: 26, verses: [])
    }

    private static func createSurah89() -> Surah {
        // Al-Fajr - 30 verses
        return Surah(surahNumber: 89, name: "Al-Fajr", arabicName: "الفجر", revelationType: "Meccan", numberOfVerses: 30, verses: [])
    }

    private static func createSurah90() -> Surah {
        // Al-Balad - 20 verses
        return Surah(surahNumber: 90, name: "Al-Balad", arabicName: "البلد", revelationType: "Meccan", numberOfVerses: 20, verses: [])
    }

    private static func createSurah91() -> Surah {
        // Ash-Shams - 15 verses
        return Surah(surahNumber: 91, name: "Ash-Shams", arabicName: "الشمس", revelationType: "Meccan", numberOfVerses: 15, verses: [])
    }

    private static func createSurah92() -> Surah {
        // Al-Layl - 21 verses
        return Surah(surahNumber: 92, name: "Al-Layl", arabicName: "الليل", revelationType: "Meccan", numberOfVerses: 21, verses: [])
    }

    private static func createSurah93() -> Surah {
        // Ad-Duhaa - 11 verses
        return Surah(surahNumber: 93, name: "Ad-Duhaa", arabicName: "الضحى", revelationType: "Meccan", numberOfVerses: 11, verses: [])
    }

    private static func createSurah94() -> Surah {
        // Ash-Sharh - 8 verses
        return Surah(surahNumber: 94, name: "Ash-Sharh", arabicName: "الشرح", revelationType: "Meccan", numberOfVerses: 8, verses: [])
    }

    private static func createSurah95() -> Surah {
        // At-Tin - 8 verses
        return Surah(surahNumber: 95, name: "At-Tin", arabicName: "التين", revelationType: "Meccan", numberOfVerses: 8, verses: [])
    }

    private static func createSurah96() -> Surah {
        // Al-Alaq - 19 verses
        return Surah(surahNumber: 96, name: "Al-Alaq", arabicName: "العلق", revelationType: "Meccan", numberOfVerses: 19, verses: [])
    }

    private static func createSurah97() -> Surah {
        // Al-Qadr - 5 verses
        return Surah(surahNumber: 97, name: "Al-Qadr", arabicName: "القدر", revelationType: "Meccan", numberOfVerses: 5, verses: [])
    }

    private static func createSurah98() -> Surah {
        // Al-Bayyinah - 8 verses
        return Surah(surahNumber: 98, name: "Al-Bayyinah", arabicName: "البينة", revelationType: "Medinan", numberOfVerses: 8, verses: [])
    }

    private static func createSurah99() -> Surah {
        // Az-Zalzalah - 8 verses
        return Surah(surahNumber: 99, name: "Az-Zalzalah", arabicName: "الزلزلة", revelationType: "Medinan", numberOfVerses: 8, verses: [])
    }

    private static func createSurah100() -> Surah {
        // Al-Adiyat - 11 verses
        return Surah(surahNumber: 100, name: "Al-Adiyat", arabicName: "العاديات", revelationType: "Meccan", numberOfVerses: 11, verses: [])
    }

    private static func createSurah101() -> Surah {
        // Al-Qari'ah - 11 verses
        return Surah(surahNumber: 101, name: "Al-Qari'ah", arabicName: "القارعة", revelationType: "Meccan", numberOfVerses: 11, verses: [])
    }

    private static func createSurah102() -> Surah {
        // At-Takathur - 8 verses
        return Surah(surahNumber: 102, name: "At-Takathur", arabicName: "التكاثر", revelationType: "Meccan", numberOfVerses: 8, verses: [])
    }

    private static func createSurah104() -> Surah {
        // Al-Humazah - 9 verses
        return Surah(surahNumber: 104, name: "Al-Humazah", arabicName: "الهمزة", revelationType: "Meccan", numberOfVerses: 9, verses: [])
    }

    private static func createSurah105() -> Surah {
        // Al-Fil - 5 verses
        return Surah(surahNumber: 105, name: "Al-Fil", arabicName: "الفيل", revelationType: "Meccan", numberOfVerses: 5, verses: [])
    }

    private static func createSurah107() -> Surah {
        // Al-Ma'un - 7 verses
        return Surah(surahNumber: 107, name: "Al-Ma'un", arabicName: "الماعون", revelationType: "Meccan", numberOfVerses: 7, verses: [])
    }

    private static func createSurah109() -> Surah {
        // Al-Kafirun - 6 verses
        return Surah(surahNumber: 109, name: "Al-Kafirun", arabicName: "الكافرون", revelationType: "Meccan", numberOfVerses: 6, verses: [])
    }

    private static func createSurah111() -> Surah {
        // Al-Masad - 5 verses
        return Surah(surahNumber: 111, name: "Al-Masad", arabicName: "المسد", revelationType: "Meccan", numberOfVerses: 5, verses: [])
    }
}
