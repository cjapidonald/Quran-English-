# CloudKit Schema for Quran English App

This document describes the complete CloudKit schema for syncing your SwiftData models with iCloud.

## Overview

The app uses **10 SwiftData models** that sync to CloudKit for data persistence and cross-device synchronization:

### Quran Content Models (3):
1. **QuranVerse** - Individual verses with Arabic and English text
2. **QuranWord** - Individual Arabic words with translations
3. **Surah** - Surah/Chapter information

### User Private Data Models (7):
4. **QuranNote** - User's personal notes on verses
5. **NoteCategory** - Custom categories for organizing notes
6. **FavoriteVerse** - Verses marked as favorites
7. **MemorizedVerse** - Verses the user has memorized
8. **ReadingProgress** - Scroll progress tracking per Surah
9. **VerseViewProgress** - Tracks which verses have been viewed
10. **SavedWord** - Vocabulary learning feature - words saved for study

All user data is stored in the **private CloudKit database** (`iCloud.com.donald.kuranianglisht`) and syncs across devices signed in with the same Apple ID.

## How to Set Up CloudKit Container

### 1. Enable CloudKit in Xcode
1. Open your project in Xcode
2. Select your target → **Signing & Capabilities**
3. Click **+ Capability** and add **iCloud**
4. Check **CloudKit**
5. Create or select a CloudKit container (e.g., `iCloud.com.yourname.QuranEnglish`)

### 2. Create Record Types in CloudKit Dashboard

Go to [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard) and create the following record types:

---

## Record Type: `CD_QuranVerse`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_verseNumber` | Int(64) | Queryable, Sortable |
| `CD_fullEnglishTranslation` | String | |
| `CD_words` | Reference List | References: `CD_QuranWord` |

**Indexes:**
- `CD_surahNumber` (Queryable, Sortable)
- `CD_verseNumber` (Queryable, Sortable)

---

## Record Type: `CD_QuranWord`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_arabic` | String | |
| `CD_englishTranslation` | String | |
| `CD_position` | Int(64) | Queryable, Sortable |
| `CD_verseId` | String | Queryable |

**Indexes:**
- `CD_verseId` (Queryable)
- `CD_position` (Sortable)

---

## Record Type: `CD_Surah`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_name` | String | Queryable, Searchable |
| `CD_arabicName` | String | |
| `CD_revelationType` | String | Queryable |
| `CD_numberOfVerses` | Int(64) | |
| `CD_verses` | Reference List | References: `CD_QuranVerse` |

**Indexes:**
- `CD_surahNumber` (Queryable, Sortable, Unique)
- `CD_name` (Queryable, Searchable)
- `CD_revelationType` (Queryable)

---

## Record Type: `CD_QuranNote`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_verseNumber` | Int(64) | Queryable, Sortable |
| `CD_arabicText` | String | |
| `CD_englishTranslation` | String | |
| `CD_userNote` | String | |
| `CD_createdAt` | Date/Time | Queryable, Sortable |
| `CD_updatedAt` | Date/Time | Queryable, Sortable |
| `CD_category` | Reference | References: `CD_NoteCategory` |

**Indexes:**
- `CD_surahNumber` (Queryable)
- `CD_verseNumber` (Queryable)
- `CD_createdAt` (Sortable)
- `CD_updatedAt` (Sortable)

---

## Record Type: `CD_NoteCategory`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_name` | String | Queryable, Searchable |
| `CD_colorHex` | String | |
| `CD_createdAt` | Date/Time | Queryable, Sortable |
| `CD_notes` | Reference List | References: `CD_QuranNote` |

**Indexes:**
- `CD_name` (Queryable, Searchable)
- `CD_createdAt` (Sortable)

---

## Record Type: `CD_FavoriteVerse`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_verseNumber` | Int(64) | Queryable, Sortable |
| `CD_arabicText` | String | |
| `CD_englishTranslation` | String | |
| `CD_addedAt` | Date/Time | Queryable, Sortable |

**Indexes:**
- `CD_surahNumber` (Queryable)
- `CD_verseNumber` (Queryable)
- `CD_addedAt` (Sortable)

---

## Record Type: `CD_MemorizedVerse`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_verseNumber` | Int(64) | Queryable, Sortable |
| `CD_arabicText` | String | |
| `CD_memorizedAt` | Date/Time | Queryable, Sortable |

**Indexes:**
- `CD_surahNumber` (Queryable)
- `CD_verseNumber` (Queryable)
- `CD_memorizedAt` (Sortable)

**Purpose**: Tracks verses that the user has memorized for review and tracking.

---

## Record Type: `CD_ReadingProgress`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_surahName` | String | Queryable |
| `CD_progressPercentage` | Double | Queryable, Sortable |
| `CD_lastReadAt` | Date/Time | Queryable, Sortable |

**Indexes:**
- `CD_surahNumber` (Queryable, Sortable)
- `CD_lastReadAt` (Sortable)
- `CD_progressPercentage` (Sortable)

**Purpose**: Tracks the user's reading progress for each Surah with scroll percentage.

---

## Record Type: `CD_VerseViewProgress`

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_verseNumber` | Int(64) | Queryable, Sortable |
| `CD_hasBeenViewed` | Int(64) | Queryable |
| `CD_viewedAt` | Date/Time | Queryable, Sortable |

**Indexes:**
- `CD_surahNumber` (Queryable)
- `CD_verseNumber` (Queryable)
- `CD_viewedAt` (Sortable)

**Purpose**: Tracks which verses the user has viewed for progress tracking.

**Note**: `CD_hasBeenViewed` uses Int(64) as CloudKit doesn't have a Boolean type. Use 0 for false, 1 for true.

---

## Record Type: `CD_SavedWord` (Vocabulary Learning)

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `CD_id` | String | Queryable, Searchable |
| `CD_arabicWord` | String | Queryable, Searchable |
| `CD_englishTranslation` | String | Queryable, Searchable |
| `CD_surahNumber` | Int(64) | Queryable, Sortable |
| `CD_surahName` | String | Queryable |
| `CD_verseNumber` | Int(64) | Queryable, Sortable |
| `CD_wordPosition` | Int(64) | Queryable |
| `CD_savedAt` | Date/Time | Queryable, Sortable |
| `CD_notes` | String | |
| `CD_mastered` | Int(64) | Queryable |

**Indexes:**
- `CD_arabicWord` (Queryable, Searchable)
- `CD_englishTranslation` (Queryable, Searchable)
- `CD_surahNumber` (Queryable)
- `CD_savedAt` (Sortable)
- `CD_mastered` (Queryable)

**Purpose**: User's personal vocabulary list. Words saved from translations for learning. Users can add personal notes and mark words as mastered.

**Note**: `CD_mastered` uses Int(64) as CloudKit doesn't have a Boolean type. Use 0 for false, 1 for true.

---

## Security Roles & Permissions

### For Development (Quick Setup):
Set all record types to:
- **World Readable**: Yes
- **Authenticated Users**: Read, Write, Create

### For Production:
- **QuranVerse, QuranWord, Surah**: World Readable (read-only for all users)
- **User Private Data** (QuranNote, NoteCategory, FavoriteVerse, MemorizedVerse, ReadingProgress, VerseViewProgress, SavedWord):
  - Creator: Read, Write
  - Other users: No access (private data)

---

## Notes on SwiftData + CloudKit Integration

### Automatic Sync Configuration (iOS 17+)

SwiftData can automatically sync with CloudKit when you configure it properly. Here's what you need:

1. **The `CD_` prefix** is used by SwiftData when mapping to CloudKit
2. **ModelConfiguration** should be set up for cloud sync:

```swift
let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .automatic  // or .private for user-private data
)
```

### Recommended Setup for Your App:

Since Quran data should be shared but notes should be private:

```swift
// For Quran content (shared/public)
let quranSchema = Schema([
    QuranVerse.self,
    QuranWord.self,
    Surah.self,
])

let quranConfig = ModelConfiguration(
    schema: quranSchema,
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .automatic
)

// For user-specific data (private)
let userSchema = Schema([
    QuranNote.self,
    NoteCategory.self,
    FavoriteVerse.self,
    MemorizedVerse.self,
    ReadingProgress.self,
    VerseViewProgress.self,
    SavedWord.self,  // Vocabulary learning feature
])

let userConfig = ModelConfiguration(
    schema: userSchema,
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .private("iCloud.com.donald.kuranianglisht")
)

// Create container with both configurations
let container = try ModelContainer(
    for: quranSchema + userSchema,
    configurations: [quranConfig, userConfig]
)
```

### Current Implementation (Single Container):

Your app currently uses a single configuration for all models:

```swift
let schema = Schema([
    QuranVerse.self,
    QuranWord.self,
    Surah.self,
    QuranNote.self,
    NoteCategory.self,
    FavoriteVerse.self,
    ReadingProgress.self,
    MemorizedVerse.self,
    VerseViewProgress.self,
    SavedWord.self,
])

let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .private("iCloud.com.donald.kuranianglisht")
)
```

This setup syncs all user data privately via CloudKit. Each user's vocabulary, notes, favorites, memorized verses, and reading progress are stored in their private iCloud database.

---

## Testing CloudKit Sync

### 1. Enable Development Environment
In CloudKit Dashboard:
- Switch to **Development** environment
- Deploy your schema

### 2. Test on Device
- Run your app on a device (not simulator for best results)
- Sign in with an Apple ID
- Add some notes or favorites
- Check CloudKit Dashboard → Data to see if records appear

### 3. Monitor Sync
```swift
// Add to your App struct for debugging
init() {
    // Enable CloudKit debug logging
    UserDefaults.standard.set(true, forKey: "com.apple.CoreData.CloudKitDebug")
}
```

---

## Quick Start Checklist

- [ ] Enable iCloud capability in Xcode
- [ ] Add CloudKit container
- [ ] Create record types in CloudKit Dashboard (Development)
- [ ] Set appropriate security permissions
- [ ] Update ModelConfiguration for CloudKit sync
- [ ] Test on physical device with Apple ID
- [ ] Verify data appears in CloudKit Dashboard
- [ ] Deploy schema to Production when ready

---

## Common Issues

### Issue: "Container not found"
**Solution**: Make sure your container ID matches exactly between Xcode and CloudKit Dashboard

### Issue: "Permission denied"
**Solution**: Check Security Roles in CloudKit Dashboard for each record type

### Issue: "Schema mismatch"
**Solution**: Ensure all fields have the `CD_` prefix and match the SwiftData property names

### Issue: Sync not working
**Solution**:
1. Check that you're signed into iCloud on the device
2. Verify CloudKit capability is enabled
3. Check Console logs for CloudKit errors
4. Ensure you're using `.private` or `.automatic` for cloudKitDatabase

---

## Quick Reference: All Record Types

| Record Type | Purpose | Key Fields | Privacy |
|------------|---------|------------|---------|
| `CD_QuranVerse` | Verse content | surahNumber, verseNumber, fullEnglishTranslation | Public/Shared |
| `CD_QuranWord` | Word translations | arabic, englishTranslation, position | Public/Shared |
| `CD_Surah` | Surah metadata | surahNumber, name, arabicName | Public/Shared |
| `CD_QuranNote` | User notes | surahNumber, verseNumber, userNote, category | Private |
| `CD_NoteCategory` | Note organization | name, colorHex | Private |
| `CD_FavoriteVerse` | Favorited verses | surahNumber, verseNumber, addedAt | Private |
| `CD_MemorizedVerse` | Memorized verses | surahNumber, verseNumber, memorizedAt | Private |
| `CD_ReadingProgress` | Reading tracking | surahNumber, progressPercentage, lastReadAt | Private |
| `CD_VerseViewProgress` | View tracking | surahNumber, verseNumber, hasBeenViewed | Private |
| `CD_SavedWord` | Vocabulary learning | arabicWord, englishTranslation, notes, mastered | Private |

---

## Vocabulary Feature Details

The **SavedWord** model enables users to build a personal vocabulary list:

### Features:
- **Save words from translations**: Tap a word to see its meaning, then save it to your vocabulary list
- **Context preservation**: Each saved word includes its location (Surah, verse, word position)
- **Personal notes**: Add custom notes to help remember word meanings
- **Progress tracking**: Mark words as "mastered" to track learning progress
- **Search & filter**: Search by Arabic or English, filter to show only unmastered words
- **Cross-device sync**: Vocabulary syncs via CloudKit to all user devices

### Use Cases:
1. Student learning Quranic Arabic vocabulary
2. Building a personal dictionary of frequently encountered words
3. Tracking progress in Arabic language acquisition
4. Creating custom word lists for review and memorization

---

For more information, see:
- [Apple's CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [SwiftData + CloudKit Guide](https://developer.apple.com/documentation/swiftdata/syncing-data-with-cloudkit)
