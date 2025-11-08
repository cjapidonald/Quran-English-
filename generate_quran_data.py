#!/usr/bin/env python3
"""
Quran Data Generator for Swift
Fetches complete Quran data and generates Swift code with all 114 surahs hardcoded
"""

import requests
import json
import re
import time
from bs4 import BeautifulSoup

def clean_translation(text):
    """Remove bracketed explanations from translation"""
    # Remove content in brackets and parentheses
    text = re.sub(r'\[.*?\]', '', text)
    text = re.sub(r'\(.*?\)', '', text)
    # Clean up extra spaces
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def fetch_rwwad_translation(surah_number):
    """Fetch Rwwad translation from quranenc.com"""
    print(f"  Fetching Rwwad translation for Surah {surah_number}...", flush=True)
    url = f"https://quranenc.com/sq/browse/english_rwwad/{surah_number}"

    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        verses = []

        # Find all verse translations
        verse_elements = soup.find_all('div', class_='aya-text')
        if not verse_elements:
            verse_elements = soup.find_all('div', class_='trans')

        for verse_elem in verse_elements:
            text = verse_elem.get_text(strip=True)
            cleaned = clean_translation(text)
            if cleaned:
                verses.append(cleaned)

        return verses
    except Exception as e:
        print(f"    Error fetching Rwwad translation: {e}")
        return []

def fetch_quran_api_data(surah_number):
    """Fetch Arabic text and word data from quran.com API"""
    print(f"  Fetching word-by-word data for Surah {surah_number}...", flush=True)
    url = f"https://api.quran.com/api/v4/verses/by_chapter/{surah_number}"
    params = {
        'words': 'true',
        'translations': '131',  # English translation
        'language': 'en',
        'word_fields': 'text_uthmani,translation'
    }

    try:
        response = requests.get(url, params=params, timeout=30)
        response.raise_for_status()
        data = response.json()
        return data.get('verses', [])
    except Exception as e:
        print(f"    Error fetching API data: {e}")
        return []

def generate_swift_verse(surah_num, verse_num, verse_data, rwwad_translation):
    """Generate Swift code for a single verse"""
    # Use Rwwad translation if available, otherwise use API translation
    if rwwad_translation:
        translation = rwwad_translation
    elif 'translations' in verse_data and verse_data['translations']:
        translation = clean_translation(verse_data['translations'][0]['text'])
    else:
        translation = "Translation not available"

    # Escape quotes in translation
    translation = translation.replace('"', '\\"')

    swift_code = f"""
    // Verse {verse_num}
    let v{verse_num} = QuranVerse(surahNumber: {surah_num}, verseNumber: {verse_num}, words: [], fullEnglishTranslation: "{translation}")
    v{verse_num}.words = ["""

    # Add words
    if 'words' in verse_data and verse_data['words']:
        word_entries = []
        position = 0
        for word in verse_data['words']:
            arabic = word.get('text_uthmani', word.get('text', ''))
            # Get word translation
            trans = word.get('translation', {}).get('text', '')
            if not trans:
                trans = clean_translation(word.get('text', 'word'))

            # Clean and escape
            arabic = arabic.replace('"', '\\"')
            trans = clean_translation(trans).replace('"', '\\"')

            word_entries.append(f'QuranWord(arabic: "{arabic}", englishTranslation: "{trans}", position: {position})')
            position += 1

        swift_code += "\n        " + ",\n        ".join(word_entries)

    swift_code += "\n    ]\n    verses.append(v" + str(verse_num) + ")\n"

    return swift_code

def generate_surah_function(surah_meta, rwwad_verses, api_verses):
    """Generate complete Swift function for a surah"""
    surah_num = surah_meta['number']
    surah_name = surah_meta['name']
    arabic_name = surah_meta['arabicName']
    revelation = surah_meta['revelationType']
    verse_count = surah_meta['verses']

    print(f"\nGenerating Surah {surah_num}: {surah_name} ({verse_count} verses)")

    swift_code = f"""
    // MARK: - Surah {surah_num}: {surah_name}
    private static func createSurah{surah_num}() -> Surah {{
        var verses: [QuranVerse] = []
"""

    # Generate each verse
    for i in range(verse_count):
        verse_num = i + 1
        rwwad_trans = rwwad_verses[i] if i < len(rwwad_verses) else ""
        api_verse = api_verses[i] if i < len(api_verses) else {}

        swift_code += generate_swift_verse(surah_num, verse_num, api_verse, rwwad_trans)

    swift_code += f"""
        return Surah(surahNumber: {surah_num}, name: "{surah_name}", arabicName: "{arabic_name}", revelationType: "{revelation}", numberOfVerses: {verse_count}, verses: verses)
    }}
"""

    return swift_code

def generate_complete_swift_file():
    """Generate complete Swift file with all 114 surahs"""

    # Surah metadata
    surahs_meta = [
        {"number": 1, "name": "Al-Fatiha", "arabicName": "الفاتحة", "revelationType": "Meccan", "verses": 7},
        {"number": 2, "name": "Al-Baqarah", "arabicName": "البقرة", "revelationType": "Medinan", "verses": 286},
        {"number": 3, "name": "Ali 'Imran", "arabicName": "آل عمران", "revelationType": "Medinan", "verses": 200},
        {"number": 4, "name": "An-Nisa", "arabicName": "النساء", "revelationType": "Medinan", "verses": 176},
        {"number": 5, "name": "Al-Ma'idah", "arabicName": "المائدة", "revelationType": "Medinan", "verses": 120},
        {"number": 6, "name": "Al-An'am", "arabicName": "الأنعام", "revelationType": "Meccan", "verses": 165},
        {"number": 7, "name": "Al-A'raf", "arabicName": "الأعراف", "revelationType": "Meccan", "verses": 206},
        {"number": 8, "name": "Al-Anfal", "arabicName": "الأنفال", "revelationType": "Medinan", "verses": 75},
        {"number": 9, "name": "At-Tawbah", "arabicName": "التوبة", "revelationType": "Medinan", "verses": 129},
        {"number": 10, "name": "Yunus", "arabicName": "يونس", "revelationType": "Meccan", "verses": 109},
        {"number": 11, "name": "Hud", "arabicName": "هود", "revelationType": "Meccan", "verses": 123},
        {"number": 12, "name": "Yusuf", "arabicName": "يوسف", "revelationType": "Meccan", "verses": 111},
        {"number": 13, "name": "Ar-Ra'd", "arabicName": "الرعد", "revelationType": "Medinan", "verses": 43},
        {"number": 14, "name": "Ibrahim", "arabicName": "ابراهيم", "revelationType": "Meccan", "verses": 52},
        {"number": 15, "name": "Al-Hijr", "arabicName": "الحجر", "revelationType": "Meccan", "verses": 99},
        {"number": 16, "name": "An-Nahl", "arabicName": "النحل", "revelationType": "Meccan", "verses": 128},
        {"number": 17, "name": "Al-Isra", "arabicName": "الإسراء", "revelationType": "Meccan", "verses": 111},
        {"number": 18, "name": "Al-Kahf", "arabicName": "الكهف", "revelationType": "Meccan", "verses": 110},
        {"number": 19, "name": "Maryam", "arabicName": "مريم", "revelationType": "Meccan", "verses": 98},
        {"number": 20, "name": "Taha", "arabicName": "طه", "revelationType": "Meccan", "verses": 135},
        {"number": 21, "name": "Al-Anbya", "arabicName": "الأنبياء", "revelationType": "Meccan", "verses": 112},
        {"number": 22, "name": "Al-Hajj", "arabicName": "الحج", "revelationType": "Medinan", "verses": 78},
        {"number": 23, "name": "Al-Mu'minun", "arabicName": "المؤمنون", "revelationType": "Meccan", "verses": 118},
        {"number": 24, "name": "An-Nur", "arabicName": "النور", "revelationType": "Medinan", "verses": 64},
        {"number": 25, "name": "Al-Furqan", "arabicName": "الفرقان", "revelationType": "Meccan", "verses": 77},
        {"number": 26, "name": "Ash-Shu'ara", "arabicName": "الشعراء", "revelationType": "Meccan", "verses": 227},
        {"number": 27, "name": "An-Naml", "arabicName": "النمل", "revelationType": "Meccan", "verses": 93},
        {"number": 28, "name": "Al-Qasas", "arabicName": "القصص", "revelationType": "Meccan", "verses": 88},
        {"number": 29, "name": "Al-'Ankabut", "arabicName": "العنكبوت", "revelationType": "Meccan", "verses": 69},
        {"number": 30, "name": "Ar-Rum", "arabicName": "الروم", "revelationType": "Meccan", "verses": 60},
        {"number": 31, "name": "Luqman", "arabicName": "لقمان", "revelationType": "Meccan", "verses": 34},
        {"number": 32, "name": "As-Sajdah", "arabicName": "السجدة", "revelationType": "Meccan", "verses": 30},
        {"number": 33, "name": "Al-Ahzab", "arabicName": "الأحزاب", "revelationType": "Medinan", "verses": 73},
        {"number": 34, "name": "Saba", "arabicName": "سبإ", "revelationType": "Meccan", "verses": 54},
        {"number": 35, "name": "Fatir", "arabicName": "فاطر", "revelationType": "Meccan", "verses": 45},
        {"number": 36, "name": "Ya-Sin", "arabicName": "يس", "revelationType": "Meccan", "verses": 83},
        {"number": 37, "name": "As-Saffat", "arabicName": "الصافات", "revelationType": "Meccan", "verses": 182},
        {"number": 38, "name": "Sad", "arabicName": "ص", "revelationType": "Meccan", "verses": 88},
        {"number": 39, "name": "Az-Zumar", "arabicName": "الزمر", "revelationType": "Meccan", "verses": 75},
        {"number": 40, "name": "Ghafir", "arabicName": "غافر", "revelationType": "Meccan", "verses": 85},
        {"number": 41, "name": "Fussilat", "arabicName": "فصلت", "revelationType": "Meccan", "verses": 54},
        {"number": 42, "name": "Ash-Shuraa", "arabicName": "الشورى", "revelationType": "Meccan", "verses": 53},
        {"number": 43, "name": "Az-Zukhruf", "arabicName": "الزخرف", "revelationType": "Meccan", "verses": 89},
        {"number": 44, "name": "Ad-Dukhan", "arabicName": "الدخان", "revelationType": "Meccan", "verses": 59},
        {"number": 45, "name": "Al-Jathiyah", "arabicName": "الجاثية", "revelationType": "Meccan", "verses": 37},
        {"number": 46, "name": "Al-Ahqaf", "arabicName": "الأحقاف", "revelationType": "Meccan", "verses": 35},
        {"number": 47, "name": "Muhammad", "arabicName": "محمد", "revelationType": "Medinan", "verses": 38},
        {"number": 48, "name": "Al-Fath", "arabicName": "الفتح", "revelationType": "Medinan", "verses": 29},
        {"number": 49, "name": "Al-Hujurat", "arabicName": "الحجرات", "revelationType": "Medinan", "verses": 18},
        {"number": 50, "name": "Qaf", "arabicName": "ق", "revelationType": "Meccan", "verses": 45},
        {"number": 51, "name": "Adh-Dhariyat", "arabicName": "الذاريات", "revelationType": "Meccan", "verses": 60},
        {"number": 52, "name": "At-Tur", "arabicName": "الطور", "revelationType": "Meccan", "verses": 49},
        {"number": 53, "name": "An-Najm", "arabicName": "النجم", "revelationType": "Meccan", "verses": 62},
        {"number": 54, "name": "Al-Qamar", "arabicName": "القمر", "revelationType": "Meccan", "verses": 55},
        {"number": 55, "name": "Ar-Rahman", "arabicName": "الرحمن", "revelationType": "Medinan", "verses": 78},
        {"number": 56, "name": "Al-Waqi'ah", "arabicName": "الواقعة", "revelationType": "Meccan", "verses": 96},
        {"number": 57, "name": "Al-Hadid", "arabicName": "الحديد", "revelationType": "Medinan", "verses": 29},
        {"number": 58, "name": "Al-Mujadila", "arabicName": "المجادلة", "revelationType": "Medinan", "verses": 22},
        {"number": 59, "name": "Al-Hashr", "arabicName": "الحشر", "revelationType": "Medinan", "verses": 24},
        {"number": 60, "name": "Al-Mumtahanah", "arabicName": "الممتحنة", "revelationType": "Medinan", "verses": 13},
        {"number": 61, "name": "As-Saf", "arabicName": "الصف", "revelationType": "Medinan", "verses": 14},
        {"number": 62, "name": "Al-Jumu'ah", "arabicName": "الجمعة", "revelationType": "Medinan", "verses": 11},
        {"number": 63, "name": "Al-Munafiqun", "arabicName": "المنافقون", "revelationType": "Medinan", "verses": 11},
        {"number": 64, "name": "At-Taghabun", "arabicName": "التغابن", "revelationType": "Medinan", "verses": 18},
        {"number": 65, "name": "At-Talaq", "arabicName": "الطلاق", "revelationType": "Medinan", "verses": 12},
        {"number": 66, "name": "At-Tahrim", "arabicName": "التحريم", "revelationType": "Medinan", "verses": 12},
        {"number": 67, "name": "Al-Mulk", "arabicName": "الملك", "revelationType": "Meccan", "verses": 30},
        {"number": 68, "name": "Al-Qalam", "arabicName": "القلم", "revelationType": "Meccan", "verses": 52},
        {"number": 69, "name": "Al-Haqqah", "arabicName": "الحاقة", "revelationType": "Meccan", "verses": 52},
        {"number": 70, "name": "Al-Ma'arij", "arabicName": "المعارج", "revelationType": "Meccan", "verses": 44},
        {"number": 71, "name": "Nuh", "arabicName": "نوح", "revelationType": "Meccan", "verses": 28},
        {"number": 72, "name": "Al-Jinn", "arabicName": "الجن", "revelationType": "Meccan", "verses": 28},
        {"number": 73, "name": "Al-Muzzammil", "arabicName": "المزمل", "revelationType": "Meccan", "verses": 20},
        {"number": 74, "name": "Al-Muddaththir", "arabicName": "المدثر", "revelationType": "Meccan", "verses": 56},
        {"number": 75, "name": "Al-Qiyamah", "arabicName": "القيامة", "revelationType": "Meccan", "verses": 40},
        {"number": 76, "name": "Al-Insan", "arabicName": "الانسان", "revelationType": "Medinan", "verses": 31},
        {"number": 77, "name": "Al-Mursalat", "arabicName": "المرسلات", "revelationType": "Meccan", "verses": 50},
        {"number": 78, "name": "An-Naba", "arabicName": "النبإ", "revelationType": "Meccan", "verses": 40},
        {"number": 79, "name": "An-Nazi'at", "arabicName": "النازعات", "revelationType": "Meccan", "verses": 46},
        {"number": 80, "name": "Abasa", "arabicName": "عبس", "revelationType": "Meccan", "verses": 42},
        {"number": 81, "name": "At-Takwir", "arabicName": "التكوير", "revelationType": "Meccan", "verses": 29},
        {"number": 82, "name": "Al-Infitar", "arabicName": "الإنفطار", "revelationType": "Meccan", "verses": 19},
        {"number": 83, "name": "Al-Mutaffifin", "arabicName": "المطففين", "revelationType": "Meccan", "verses": 36},
        {"number": 84, "name": "Al-Inshiqaq", "arabicName": "الإنشقاق", "revelationType": "Meccan", "verses": 25},
        {"number": 85, "name": "Al-Buruj", "arabicName": "البروج", "revelationType": "Meccan", "verses": 22},
        {"number": 86, "name": "At-Tariq", "arabicName": "الطارق", "revelationType": "Meccan", "verses": 17},
        {"number": 87, "name": "Al-A'la", "arabicName": "الأعلى", "revelationType": "Meccan", "verses": 19},
        {"number": 88, "name": "Al-Ghashiyah", "arabicName": "الغاشية", "revelationType": "Meccan", "verses": 26},
        {"number": 89, "name": "Al-Fajr", "arabicName": "الفجر", "revelationType": "Meccan", "verses": 30},
        {"number": 90, "name": "Al-Balad", "arabicName": "البلد", "revelationType": "Meccan", "verses": 20},
        {"number": 91, "name": "Ash-Shams", "arabicName": "الشمس", "revelationType": "Meccan", "verses": 15},
        {"number": 92, "name": "Al-Layl", "arabicName": "الليل", "revelationType": "Meccan", "verses": 21},
        {"number": 93, "name": "Ad-Duhaa", "arabicName": "الضحى", "revelationType": "Meccan", "verses": 11},
        {"number": 94, "name": "Ash-Sharh", "arabicName": "الشرح", "revelationType": "Meccan", "verses": 8},
        {"number": 95, "name": "At-Tin", "arabicName": "التين", "revelationType": "Meccan", "verses": 8},
        {"number": 96, "name": "Al-'Alaq", "arabicName": "العلق", "revelationType": "Meccan", "verses": 19},
        {"number": 97, "name": "Al-Qadr", "arabicName": "القدر", "revelationType": "Meccan", "verses": 5},
        {"number": 98, "name": "Al-Bayyinah", "arabicName": "البينة", "revelationType": "Medinan", "verses": 8},
        {"number": 99, "name": "Az-Zalzalah", "arabicName": "الزلزلة", "revelationType": "Medinan", "verses": 8},
        {"number": 100, "name": "Al-'Adiyat", "arabicName": "العاديات", "revelationType": "Meccan", "verses": 11},
        {"number": 101, "name": "Al-Qari'ah", "arabicName": "القارعة", "revelationType": "Meccan", "verses": 11},
        {"number": 102, "name": "At-Takathur", "arabicName": "التكاثر", "revelationType": "Meccan", "verses": 8},
        {"number": 103, "name": "Al-'Asr", "arabicName": "العصر", "revelationType": "Meccan", "verses": 3},
        {"number": 104, "name": "Al-Humazah", "arabicName": "الهمزة", "revelationType": "Meccan", "verses": 9},
        {"number": 105, "name": "Al-Fil", "arabicName": "الفيل", "revelationType": "Meccan", "verses": 5},
        {"number": 106, "name": "Quraysh", "arabicName": "قريش", "revelationType": "Meccan", "verses": 4},
        {"number": 107, "name": "Al-Ma'un", "arabicName": "الماعون", "revelationType": "Meccan", "verses": 7},
        {"number": 108, "name": "Al-Kawthar", "arabicName": "الكوثر", "revelationType": "Meccan", "verses": 3},
        {"number": 109, "name": "Al-Kafirun", "arabicName": "الكافرون", "revelationType": "Meccan", "verses": 6},
        {"number": 110, "name": "An-Nasr", "arabicName": "النصر", "revelationType": "Medinan", "verses": 3},
        {"number": 111, "name": "Al-Masad", "arabicName": "المسد", "revelationType": "Meccan", "verses": 5},
        {"number": 112, "name": "Al-Ikhlas", "arabicName": "الإخلاص", "revelationType": "Meccan", "verses": 4},
        {"number": 113, "name": "Al-Falaq", "arabicName": "الفلق", "revelationType": "Meccan", "verses": 5},
        {"number": 114, "name": "An-Nas", "arabicName": "الناس", "revelationType": "Meccan", "verses": 6}
    ]

    print("=" * 60, flush=True)
    print("Quran Data Generator", flush=True)
    print("=" * 60, flush=True)
    print(f"Total surahs to process: {len(surahs_meta)}", flush=True)
    print("This will take approximately 10-15 minutes...", flush=True)
    print("=" * 60, flush=True)

    # Start Swift file
    swift_content = """//
//  ComprehensiveQuranData.swift
//  Quran English
//
//  AUTO-GENERATED - Complete Quran dataset with Rwwad translation
//  Word-by-word translations exclude text in brackets
//  Generated using generate_quran_data.py
//

import Foundation

struct ComprehensiveQuranData {

    // MARK: - Main Data Loader
    static func createAllSurahs() -> [Surah] {
        var surahs: [Surah] = []

"""

    # Add all surah function calls
    for meta in surahs_meta:
        swift_content += f"        surahs.append(createSurah{meta['number']}())\n"

    swift_content += """
        return surahs.sorted { $0.surahNumber < $1.surahNumber }
    }
"""

    # Generate each surah
    for i, meta in enumerate(surahs_meta, 1):
        print(f"\nProcessing Surah {i}/114: {meta['name']}", flush=True)

        # Fetch Rwwad translation
        rwwad_verses = fetch_rwwad_translation(meta['number'])
        time.sleep(1)  # Be nice to the server

        # Fetch API data
        api_verses = fetch_quran_api_data(meta['number'])
        time.sleep(1)  # Be nice to the server

        # Generate Swift code
        surah_code = generate_surah_function(meta, rwwad_verses, api_verses)
        swift_content += surah_code

        print(f"  ✓ Completed Surah {meta['number']}", flush=True)

        # Save progress every 10 surahs
        if i % 10 == 0:
            print(f"\n>>> Checkpoint: {i}/114 surahs completed ({i/114*100:.1f}%)", flush=True)

    # Close the struct
    swift_content += "\n}\n"

    return swift_content

def main():
    """Main execution"""
    output_file = "Quran English/Data/ComprehensiveQuranData_Generated.swift"

    print("\nStarting Quran data generation...")
    print(f"Output file: {output_file}\n")

    try:
        swift_code = generate_complete_swift_file()

        # Write to file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(swift_code)

        print("\n" + "=" * 60)
        print("✓ SUCCESS!")
        print("=" * 60)
        print(f"Generated file: {output_file}")
        print("\nNext steps:")
        print("1. Open Xcode")
        print("2. Remove the old ComprehensiveQuranData.swift file")
        print("3. Add ComprehensiveQuranData_Generated.swift to your project")
        print("4. Build and run!")
        print("=" * 60)

    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
