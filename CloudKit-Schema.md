# CloudKit Schema for Quran English App

This document describes the CloudKit schema for syncing your SwiftData models.

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

## Security Roles & Permissions

### For Development (Quick Setup):
Set all record types to:
- **World Readable**: Yes
- **Authenticated Users**: Read, Write, Create

### For Production:
- **QuranVerse, QuranWord, Surah**: World Readable (read-only for all users)
- **QuranNote, NoteCategory, FavoriteVerse**:
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
])

let userConfig = ModelConfiguration(
    schema: userSchema,
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .private
)

// Create container with both configurations
let container = try ModelContainer(
    for: quranSchema + userSchema,
    configurations: [quranConfig, userConfig]
)
```

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

For more information, see:
- [Apple's CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [SwiftData + CloudKit Guide](https://developer.apple.com/documentation/swiftdata/syncing-data-with-cloudkit)
