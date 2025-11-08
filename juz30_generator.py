#!/usr/bin/env python3
import requests
import json
import re

# Rwwad translations collected
rwwad_translations = {
    78: ["About what are they asking one another?", "About the momentous news.", "That which they differ about.", "No indeed; they will come to know.", "Again no; they will come to know.", "Have We not made the earth a resting place?", "And the mountains as stakes.", "And created you in pairs.", "And made your sleep for rest.", "And made the night a covering.", "And made the day for seeking a livelihood.", "And built above you seven mighty heavens.", "And made therein a blazing lamp.", "And sent down from the rainclouds abundant water.", "So that We may produce thereby grains and vegetation.", "And gardens with dense foliage?", "Indeed, the Day of Judgment is a time appointed.", "The Day when the Trumpet will be blown, you will come forth in crowds.", "And the sky will be opened up and will become gateways.", "And the mountains will vanish, becoming like a mirage.", "Indeed, Hell is lying in wait.", "A resort for the transgressors.", "Wherein they will abide for endless ages.", "They will neither taste therein any coolness nor any drink.", "Except for scalding water and discharge of wounds.", "A fitting recompense.", "Indeed, they did not expect a reckoning.", "And utterly rejected Our verses.", "But We have enumerated everything in a record.", "So taste the punishment, for We will not increase you except in torment.", "Indeed, the righteous will have salvation.", "Gardens and vineyards.", "And full-bosomed maidens of equal age.", "And a full cup of wine.", "They will not hear therein vain talk or lies.", "A reward and a generous gift from your Lord.", "From the Lord of the heavens and earth and all that is between them, the Most Compassionate; none will dare to speak to Him.", "On the Day when the Spirit and the angels will stand in rows; none will dare to speak, except those to whom the Most Compassionate granted permission, and they will only speak the truth.", "That Day is sure to come. So whoever wills may seek a path leading to his Lord.", "Indeed, We have warned you of an imminent punishment on the Day when everyone will see what his hands have sent forth, and the disbeliever will say, \"Oh, I wish that I were dust!\""],
    79: ["By those who pull out evil souls harshly", "and by those who draw out good souls gently", "and by those who glide swiftly", "and those who overtake one another as in a race", "and those who carry out the command of Allah", "on the Day when the earth convulses by the first Blast", "followed by the second Blast", "hearts will be pounding on that Day", "and their eyes will be downcast", "They say, \"Will we be brought back to life", "after we have turned into decayed bones?\"", "They say, \"Then that would surely be a losing return!\"", "It will only be a single Blast", "then they will immediately be above the ground", "Has there come to you the story of Moses", "when his Lord called out to him at the sacred valley of Tuwa?", "\"Go to Pharaoh, for he has transgressed all bounds\"", "And say: 'Are you willing to be purified", "and I will guide you to your Lord so that you may fear Him?'\"", "Then Moses showed him the greatest sign", "But Pharaoh denied it and disobeyed", "Then he turned back striving to plot", "He gathered his people and proclaimed", "saying, \"I am your lord, the most high\"", "So Allah seized him for exemplary punishment in this life and the Hereafter", "Indeed, there is a lesson in this for those who fear Allah", "Are you more difficult to create or the heaven that He built?", "He raised its vault high and proportioned it", "and darkened its night and brought forth its daylight", "And thereafter He spread out the earth", "brought forth from it its water and its pasture", "and set the mountains firmly", "as a provision for you and your grazing livestock", "But when the Supreme Calamity comes", "on that Day man will remember all what he did", "and the Blazing Fire will be exposed for all to see", "As for those who transgressed", "and preferred the life of this world", "the Blazing Fire will be their abode", "But those who feared standing before their Lord and restrained themselves from evil desires", "Paradise will surely be their abode", "They ask you concerning the Hour, \"When will it be?\"", "How could you possibly mention that?", "Its knowledge rests only with your Lord", "You are only a warner for those who fear it", "On the Day when they see it, it will be as if they had remained in this world no more than an evening or a morning"],
    80: ["He frowned and turned away", "when the blind man came to him", "How would you know? Perhaps he might be purified", "or he might take heed and benefit from the reminder?", "But he who was indifferent", "you give him your full attention", "although you are not to be blamed if he does not purify himself", "But as for the one who came to you striving", "and he fears Allah", "you let yourself be distracted from him", "No indeed; this is a reminder", "so whoever wills may give heed to it", "on venerable pages", "exalted and purified", "in the hands of angel-scribes", "honorable and obedient", "Woe to man; how ungrateful he is", "From what did He create him?", "He created him from a drop of semen and proportioned him", "then He made the way easy for him", "then He caused him to die and be buried", "then when He wills, He will resurrect him", "Yet he has not fulfilled what He commanded him", "Let man consider the food he eats", "How We pour down rainwater in torrents", "and cause the soil to split open", "and cause grains to grow in it", "as well as grapes and fodder", "and olive trees and date palms", "and dense orchards", "and fruits and grass", "as provision for you and your livestock", "But when the Deafening Blast comes", "on that Day everyone will flee from his brother", "and from his mother and father", "and from his wife and children", "On that day, everyone will have enough concern of his own", "On that Day, some faces will be bright", "cheerful and rejoicing", "while other faces will be dust-stained", "covered in darkness", "Such are the disbelievers, the wicked"],
    81: ["When the sun is wrapped up in darkness", "and when the stars fall down", "and when the mountains are set in motion", "and when pregnant camels are left unattended", "and when wild beasts are gathered", "and when the seas are set on fire", "and when the souls are sorted", "and when the baby girl buried alive is asked", "for what crime she was killed", "and when records of deeds are spread open", "and when the sky is stripped away", "and when the Blazing Fire is flared up", "and when Paradise is brought near", "then every soul will know what it has brought about", "I swear by the receding stars", "that rise and hide", "and by the night as it departs", "and by the day as it breaks", "Indeed, this is a word conveyed by a noble angel-messenger", "extremely powerful, highly revered by the Lord of the Throne", "obeyed there and trustworthy", "Your fellow is not a madman", "He indeed saw him on the clear horizon", "He does not withhold knowledge of the unseen", "This is not the word of an accursed devil", "So which way are you going", "It is but a reminder to the worlds", "for those among you who wish to take the straight path", "But you cannot wish except by the Will of Allah, the Lord of the worlds"],
    82: ["When the sky breaks apart.", "and when the stars fall, scattered,", "and when the seas burst forth,", "and when the graves are overturned,", "then each soul will come to know what it has done or what it has left undone.", "O mankind, what has lured you away from your Lord, the Most Generous,", "Who created you, then shaped and proportioned you,", "and assembled you in whatever form He willed?", "No indeed; but you deny the Judgment Day,", "while there are watchers over you,", "honorable scribes,", "who know whatever you do.", "Indeed, the righteous will be in Bliss,", "and the wicked will be in Blazing Fire,", "which they will enter on Judgment Day,", "and will never come out of it.", "How do you know what Judgment Day is?", "Again, how do you know what Judgment Day is?", "It is the Day when no soul will be of any help to another, and all command on that Day will be with Allah."],
}

# Surah metadata
surah_info = {
    78: ("An-Naba", "النبإ", "Meccan", 40),
    79: ("An-Nazi'at", "النازعات", "Meccan", 46),
    80: ("Abasa", "عبس", "Meccan", 42),
    81: ("At-Takwir", "التكوير", "Meccan", 29),
    82: ("Al-Infitar", "الإنفطار", "Meccan", 19),
}

print("// Extension to ComprehensiveQuranData.swift")
print("// Juz 30 - Surahs 78-82 (partial)")
print()

for surah_num in range(78, 83):
    try:
        # Fetch word-by-word data from Quran.com API
        url = f"https://api.quran.com/api/v4/verses/by_chapter/{surah_num}?language=en&words=true&word_fields=text_uthmani,translation"
        response = requests.get(url)
        data = response.json()
        
        name, arabic, rev_type, num_verses = surah_info[surah_num]
        
        print(f"    // MARK: - Surah {surah_num}: {name}")
        print(f"    private static func createSurah{surah_num}() -> Surah {{")
        print(f"        var verses: [QuranVerse] = []")
        print()
        
        for verse_data in data['verses']:
            verse_num = verse_data['verse_number']
            translation = rwwad_translations[surah_num][verse_num - 1]
            
            # Clean translation - remove brackets content
            translation = re.sub(r'\[.*?\]', '', translation)
            translation = re.sub(r'\(.*?\)', '', translation)
            translation = translation.strip()
            translation = translation.replace('"', '\\"')
            
            print(f"        // Verse {verse_num}")
            print(f"        let v{verse_num} = QuranVerse(surahNumber: {surah_num}, verseNumber: {verse_num}, words: [], fullEnglishTranslation: \"{translation}\")")
            print(f"        v{verse_num}.words = [")
            
            word_position = 0
            for word_data in verse_data['words']:
                # Skip verse number markers
                if word_data.get('char_type_name') == 'end':
                    continue
                    
                arabic_text = word_data.get('text_uthmani', word_data.get('text', ''))
                translation_text = word_data.get('translation', {}).get('text', '')
                
                # Clean translation
                translation_text = translation_text.replace('"', '\\"')
                
                print(f"            QuranWord(arabic: \"{arabic_text}\", englishTranslation: \"{translation_text}\", position: {word_position}),")
                word_position += 1
            
            print(f"        ]")
            print(f"        verses.append(v{verse_num})")
            print()
        
        print(f"        return Surah(surahNumber: {surah_num}, name: \"{name}\", arabicName: \"{arabic}\", revelationType: \"{rev_type}\", numberOfVerses: {num_verses}, verses: verses)")
        print(f"    }}")
        print()
        
    except Exception as e:
        print(f"// Error processing surah {surah_num}: {e}", file=sys.stderr)

