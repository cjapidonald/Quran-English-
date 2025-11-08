# CloudKit Setup Guide for Quran English

## ⚠️ Important Note About CloudKit Schema Import

Unfortunately, CloudKit Dashboard **does not support direct JSON schema import** through the web interface. You have two options:

### Option 1: Manual Setup (Recommended for Testing)
Follow the step-by-step guide below to manually create each record type.

### Option 2: Programmatic Setup (Advanced)
Use the CloudKit Schema Management API with the provided `cloudkit-schema.json` file.

---

## Option 1: Manual Setup in CloudKit Dashboard

### Step 1: Access CloudKit Dashboard
1. Go to https://icloud.developer.apple.com/dashboard
2. Sign in with your Apple Developer account
3. Select your container (or create a new one)
4. Make sure you're in the **Development** environment

### Step 2: Create Record Types

Click on **Schema** → **Record Types** → **+** (to add new record type)

---

#### Record Type 1: `CD_QuranVerse`

**Create Record Type:**
- Name: `CD_QuranVerse`

**Add Fields** (click **Add Field** for each):
1. Field Name: `CD_id`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

2. Field Name: `CD_surahNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

3. Field Name: `CD_verseNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

4. Field Name: `CD_fullEnglishTranslation`, Type: **String**

5. Field Name: `CD_words`, Type: **Reference List**
   - Reference Type: `CD_QuranWord`
   - Note: You may need to create this field after creating CD_QuranWord

**Click Save**

---

#### Record Type 2: `CD_QuranWord`

**Create Record Type:**
- Name: `CD_QuranWord`

**Add Fields:**
1. Field Name: `CD_arabic`, Type: **String**

2. Field Name: `CD_englishTranslation`, Type: **String**

3. Field Name: `CD_position`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

4. Field Name: `CD_verseId`, Type: **String**
   - ☑️ Enable for Queries

**Click Save**

---

#### Record Type 3: `CD_Surah`

**Create Record Type:**
- Name: `CD_Surah`

**Add Fields:**
1. Field Name: `CD_id`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

2. Field Name: `CD_surahNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

3. Field Name: `CD_name`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

4. Field Name: `CD_arabicName`, Type: **String**

5. Field Name: `CD_revelationType`, Type: **String**
   - ☑️ Enable for Queries

6. Field Name: `CD_numberOfVerses`, Type: **Int(64)**

7. Field Name: `CD_verses`, Type: **Reference List**
   - Reference Type: `CD_QuranVerse`

**Click Save**

---

#### Record Type 4: `CD_QuranNote`

**Create Record Type:**
- Name: `CD_QuranNote`

**Add Fields:**
1. Field Name: `CD_id`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

2. Field Name: `CD_surahNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

3. Field Name: `CD_verseNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

4. Field Name: `CD_arabicText`, Type: **String**

5. Field Name: `CD_englishTranslation`, Type: **String**

6. Field Name: `CD_userNote`, Type: **String**

7. Field Name: `CD_createdAt`, Type: **Date/Time**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

8. Field Name: `CD_updatedAt`, Type: **Date/Time**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

9. Field Name: `CD_category`, Type: **Reference**
   - Reference Type: `CD_NoteCategory`

**Click Save**

---

#### Record Type 5: `CD_NoteCategory`

**Create Record Type:**
- Name: `CD_NoteCategory`

**Add Fields:**
1. Field Name: `CD_id`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

2. Field Name: `CD_name`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

3. Field Name: `CD_colorHex`, Type: **String**

4. Field Name: `CD_createdAt`, Type: **Date/Time**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

5. Field Name: `CD_notes`, Type: **Reference List**
   - Reference Type: `CD_QuranNote`

**Click Save**

---

#### Record Type 6: `CD_FavoriteVerse`

**Create Record Type:**
- Name: `CD_FavoriteVerse`

**Add Fields:**
1. Field Name: `CD_id`, Type: **String**
   - ☑️ Enable for Queries
   - ☑️ Enable for Search

2. Field Name: `CD_surahNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

3. Field Name: `CD_verseNumber`, Type: **Int(64)**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

4. Field Name: `CD_arabicText`, Type: **String**

5. Field Name: `CD_englishTranslation`, Type: **String**

6. Field Name: `CD_addedAt`, Type: **Date/Time**
   - ☑️ Enable for Queries
   - ☑️ Enable for Sort

**Click Save**

---

### Step 3: Set Security Permissions

For each record type:

1. Click on the record type
2. Go to **Security Roles** tab

**For Development/Testing:**
- **World**: Readable
- **Authenticated**: Readable, Writable, Creatable

**For Production (recommended):**

**CD_QuranVerse, CD_QuranWord, CD_Surah:**
- **World**: Readable
- **Authenticated**: Readable
- **Creator**: Readable

**CD_QuranNote, CD_NoteCategory, CD_FavoriteVerse:**
- **Creator**: Readable, Writable, Creatable
- **World**: None
- **Authenticated**: None

---

### Step 4: Deploy Schema

1. Click **Deploy Schema Changes** button
2. Confirm deployment to Development environment

---

### Step 5: Enable CloudKit in Xcode

1. Open your Xcode project
2. Select your target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability**
5. Add **iCloud**
6. Check **CloudKit**
7. Select your CloudKit container from the dropdown

---

### Step 6: Update Your Code

In `Quran_EnglishApp.swift`, uncomment the CloudKit configuration:

```swift
let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false,
    cloudKitDatabase: .private  // or .automatic
)
```

---

### Step 7: Test the Setup

1. **Build and run** your app on a **physical device** (CloudKit works better on devices)
2. Make sure the device is **signed into iCloud**
3. Add a note or favorite verse in your app
4. Go to CloudKit Dashboard → **Data**
5. Select your record type (e.g., CD_QuranNote)
6. You should see your test data appear!

---

## Option 2: Programmatic Setup (Advanced)

The `cloudkit-schema.json` file can be used with CloudKit's Schema Management API. This requires:

1. CloudKit Server-to-Server Key
2. Custom script or tool to upload schema
3. More technical setup

**Resources:**
- [CloudKit Web Services Documentation](https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitWebServicesReference/)
- Consider using tools like `cktool` (third-party)

---

## Verification Checklist

- [ ] Created all 6 record types in CloudKit Dashboard
- [ ] Added all fields with correct types
- [ ] Set queryable/sortable/searchable options
- [ ] Configured security permissions
- [ ] Deployed schema to Development environment
- [ ] Enabled iCloud + CloudKit in Xcode
- [ ] Selected correct container in Xcode
- [ ] Updated ModelConfiguration in code
- [ ] Tested on physical device
- [ ] Verified data appears in CloudKit Dashboard

---

## Troubleshooting

### "Schema mismatch" errors
- Ensure all field names have the `CD_` prefix
- Check that field types match (String, Int(64), Date/Time)
- Verify reference types point to correct record types

### Data not syncing
- Check device is signed into iCloud (Settings → Apple ID)
- Verify CloudKit capability is enabled in Xcode
- Check Console logs for errors (Cmd+Shift+Y in Xcode)
- Make sure you deployed the schema in CloudKit Dashboard
- Try using `.private` instead of `.automatic` for cloudKitDatabase

### "Container not found"
- Container ID in Xcode must match exactly with CloudKit Dashboard
- Format: `iCloud.com.yourcompany.YourAppName`

### Permission denied errors
- Check Security Roles for each record type
- For testing, allow "Authenticated" users to Read/Write/Create
- Make sure device is signed into an Apple ID

---

## Next Steps

Once your schema is set up:

1. **Test thoroughly** in Development environment
2. **Add more robust error handling** for CloudKit sync
3. **Implement conflict resolution** if needed
4. **Monitor usage** in CloudKit Dashboard
5. When ready, **deploy to Production** environment

---

## Additional Resources

- [Apple CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [SwiftData CloudKit Sync Guide](https://developer.apple.com/documentation/swiftdata/syncing-data-with-cloudkit)
- [WWDC CloudKit Sessions](https://developer.apple.com/videos/cloudkit)
