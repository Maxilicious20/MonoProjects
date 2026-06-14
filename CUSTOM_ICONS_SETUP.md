# Custom Icon Upload Setup Guide

## 🎨 What's New

Your Mono Projects application now supports **custom icon uploads for tags**! Instead of being limited to FontAwesome icons, admins can now:

✅ Upload custom SVG/PNG/JPG/GIF icons  
✅ Icons stored securely in Supabase Storage  
✅ Automatic fallback to FontAwesome if needed  
✅ Live preview before saving  

---

## 🔧 Setup Instructions

### Step 1: Create Supabase Storage Bucket

1. **Go to Supabase Dashboard**: https://app.supabase.com
2. **Navigate to Storage section** (left sidebar)
3. **Create a new bucket**:
   - Name: `tag_icons`
   - Make it **PUBLIC** (important!)
   - Click **Create Bucket**

### Step 2: Update Database Tables

The tags table now has two new fields:
- `icon` - Still stores FontAwesome class for fallback
- `icon_url` - Stores the URL of custom uploaded icon

If you haven't run the latest `supabase_setup.sql`, run these commands in your SQL Editor:

```sql
-- Add new columns to tags table (if they don't exist)
ALTER TABLE tags ADD COLUMN IF NOT EXISTS icon_url TEXT;

-- Update existing column to be nullable
ALTER TABLE tags ALTER COLUMN icon DROP NOT NULL;
```

### Step 3: Update Your Browser Cache

1. **Hard refresh** your page: **Ctrl+Shift+Delete** (Windows) or **Cmd+Shift+Delete** (Mac)
2. Go to **Application/Storage** tab
3. Clear all caches
4. Close the DevTools (F12)
5. **Hard refresh**: **Ctrl+F5** (or **Cmd+Shift+R** on Mac)

---

## 📸 How to Use Custom Icon Upload

### For Admin Users (Maxilicious20):

1. **Sign in** as admin (username: `Maxilicious20`)
2. **Click "Manage Tags"** button in top right
3. **Fill in tag details**:
   - Tag Name: *e.g., "Claude 3.5 Sonnet"*
   - Icon Representation: Select FontAwesome or skip
   - **Custom Icon Upload**: Choose your icon file
   - Color: Select accent color
4. **See preview** of your uploaded icon
5. **Click "Save Active Tag"**
6. Your custom icon appears in the tag filter pills!

### Supported Icon Formats

- `.svg` - Recommended (scalable, lightweight)
- `.png` - Good quality, small files
- `.jpg` - For photographs/complex images
- `.gif` - For animated icons
- `.webp` - Modern format, great compression

### Icon Recommendations

- **Size**: 64x64px to 256x256px ideal
- **Format**: Square aspect ratio works best
- **Colors**: Use transparent backgrounds for flexibility
- **File size**: Keep under 200KB for best performance

---

## 🎯 Icon Upload Workflow

```
1. Admin selects icon file
   ↓
2. File preview shown
   ↓
3. Admin clicks "Save Active Tag"
   ↓
4. Icon uploaded to Supabase Storage (tag_icons bucket)
   ↓
5. Public URL stored in database
   ↓
6. Icon appears everywhere tags are shown
```

---

## 🔄 Icon Sources

### Where to Find Custom Icons

**Free Icon Libraries:**
- [Feather Icons](https://feathericons.com) - Clean, minimal
- [Bootstrap Icons](https://icons.getbootstrap.com) - Comprehensive
- [Heroicons](https://heroicons.com) - Professional
- [Remix Icon](https://remixicon.com) - 3000+ icons
- [Tabler Icons](https://tabler-icons.io) - Well-designed

**AI/Tech Specific:**
- Download logos from official websites (OpenAI, Google, Anthropic, etc.)
- Use brand kits and style guides
- Create custom icons in Figma, Adobe XD, or Inkscape

---

## 🐛 Troubleshooting

### "Failed to upload icon"
- Check file size (under 200KB)
- Verify file format is supported
- Check browser console (F12) for errors
- Ensure storage bucket is public

### Icon not showing
- Clear browser cache (Ctrl+Shift+Delete)
- Hard refresh page (Ctrl+F5)
- Check if bucket name is exactly "tag_icons"
- Verify icon file URL is accessible

### Icon uploads but shows broken image
- Check Supabase Storage permissions (bucket must be public)
- Try different file format
- Reduce file size
- Check CORS settings in Supabase

### "Storage bucket not found" error
- Verify "tag_icons" bucket exists in Storage section
- Bucket must be PUBLIC (not private)
- If deleted, create new bucket with same name

---

## 📱 UI Behavior

### Icon Display Locations

**Tag Pills** (top filter bar):
- Shows custom icon if available
- Falls back to FontAwesome if not
- Scales: 16x16px

**Tag Manager Modal**:
- Shows custom icon in tag list
- 32x32px display
- Delete button next to each tag

**Project Cards**:
- Shows tag with custom icon
- Scales: 14x14px
- Multiple tags supported

**Tag Selection in Upload Form**:
- Shows custom icons in checkboxes
- Easy visual identification

---

## 🔐 Security Notes

### Best Practices

1. **Icon Validation**: Only SVG/PNG/JPG/GIF allowed
2. **File Size Limit**: 200KB per icon (enforced)
3. **Storage Bucket**: Public read, admin-only write
4. **URL Storage**: URLs stored in database for persistence

### Admin-Only Access

- Only accounts with `is_admin: true` can upload icons
- Create admin account with username: `Maxilicious20`
- All icon uploads require authentication

---

## 🚀 Advanced: Batch Icon Upload

For future enhancement, consider:

```javascript
// Pseudo-code for bulk upload
async function batchUploadIcons(files) {
  for (const file of files) {
    await uploadTagIcon(file);
  }
}
```

---

## 📊 Icon Usage Statistics

After implementing, you can track:
- Most popular tag icons
- Upload frequency
- Icon file size distribution
- Broken image reports

---

## 💡 Tips for Best Results

1. **Consistency**: Use similar icon styles/colors across tags
2. **Simplicity**: Keep icons simple and recognizable at small sizes
3. **Testing**: Preview icons at 16x16px size to see how they look
4. **Backup**: Save original icon files locally
5. **Naming**: Use clear naming convention in Storage bucket

---

## 📚 Next Steps

Now that you have custom icons, consider:
1. **Add ratings system** (⭐) to projects
2. **Create favorites** (❤️) functionality
3. **Add project versioning** for updates
4. **Implement comments** on projects
5. **Build collections** of related projects

See [FEATURE_IDEAS.md](FEATURE_IDEAS.md) for complete feature roadmap!

---

## 🆘 Need Help?

**Common Questions:**

Q: Can I upload SVGs with embedded fonts?  
A: Not recommended - may not render correctly. Use outlined SVGs instead.

Q: What happens if icon upload fails?  
A: Tag is saved without icon; FontAwesome fallback is used instead.

Q: Can I update an icon after creation?  
A: Currently no - delete and recreate tag with new icon.

Q: Is there a size limit?  
A: 200KB file size limit; recommend 64x256px dimensions.

Q: Can users upload icons or just admins?  
A: Currently admin-only. User uploads could be added in future.
