# 📊 Analytics, Versioning & Comments - Complete Feature Guide

## 🎯 What's New

Your Mono Projects platform now includes three powerful features:

### 1. **📊 Analytics Dashboard**
- Real-time download and view tracking
- Comment count monitoring
- Performance metrics per project
- **Visible on**: Project details modal

### 2. **📥 Download Tracking**
- Automatically log each download
- Track which user downloaded what version
- Analytics automatically update
- **Persisted in**: `project_downloads` table

### 3. **💬 Comments & Discussions**
- Community discussion threads
- Like/engagement system foundation
- Like counters on comments
- Thread sorting by recency
- **Persisted in**: `project_comments` table

### 4. **📦 Project Versioning & Updates**
- Create new versions of projects
- Version history with descriptions
- Download specific versions
- Default to latest version
- Admin-only version creation
- **Persisted in**: `project_versions` table

---

## 📋 Database Schema

### `project_analytics` Table
```
id (UUID) - Primary key
project_id (TEXT) - Foreign key to projects
total_downloads (INT) - Cumulative download count
total_views (INT) - Cumulative view count
total_comments (INT) - Cumulative comment count
average_rating (FLOAT) - For future ratings feature
updated_at (TIMESTAMP) - Last stat update
```

### `project_downloads` Table
```
id (UUID) - Primary key
project_id (TEXT) - Foreign key to projects
username (TEXT) - User who downloaded (nullable)
version_number (INT) - Version downloaded
downloaded_at (TIMESTAMP) - When downloaded
```

### `project_comments` Table
```
id (UUID) - Primary key
project_id (TEXT) - Foreign key to projects
username (TEXT) - Commenter username
comment_text (TEXT) - Comment content
likes (INT) - Like counter (default 0)
created_at (TIMESTAMP) - When posted
updated_at (TIMESTAMP) - Last edit time
```

### `project_versions` Table
```
id (UUID) - Primary key
project_id (TEXT) - Foreign key to projects
version_number (INT) - Version number (1, 2, 3...)
content (TEXT) - Version-specific files/content
description (TEXT) - What changed in this version
created_by (TEXT) - Admin who created version
created_at (TIMESTAMP) - When version created
UNIQUE(project_id, version_number)
```

### `project_views` Table
```
id (UUID) - Primary key
project_id (TEXT) - Foreign key to projects
username (TEXT) - User who viewed (nullable)
viewed_at (TIMESTAMP) - When viewed
```

---

## 🚀 How to Use

### For End Users

#### Viewing Project Details

1. **Browse projects** in the main grid
2. **Click "View Details"** button on any project card
3. **Details modal opens** showing:
   - Project cover image
   - Description & tags
   - **Analytics stats** (downloads, views, comments)
   - **Version selector** dropdown
   - Comments section
4. **Select different versions** to see update history
5. **Post comments** to discuss the project
6. **Download** using latest or selected version

#### Downloading Projects

- **Default behavior**: Downloads latest version
- **With versions**: Choose version from dropdown, then download
- **Analytics tracking**: Your download is automatically logged
- **File format**: Plain text archive with metadata

#### Posting Comments

1. **Sign in** with your account
2. **Open project details**
3. **Type comment** in comment box
4. **Click send button** (paper plane icon)
5. **Comment appears** in list immediately
6. **View update date** with each comment

---

### For Admins

#### Creating Project Versions

1. **Sign in as admin** (username: `Maxilicious20`)
2. **Open project details** modal
3. **Scroll to "Create New Version"** section (admin-only)
4. **Fill in update description**:
   - What changed, bug fixes, new features
5. **Fill in new content/files**:
   - Updated configurations, new files, links
6. **Click "Publish New Version"**
7. **Version counter increments** (v1 → v2 → v3)
8. **Old versions remain available** for download

#### Version Management Best Practices

- **Version 1**: Original release
- **Version 2+**: Incremental updates
- **Descriptions**: Be clear about changes ("Fixed bugs in config.py", "Added new API endpoint")
- **Content**: Update with actual file content/configuration
- **Auto-updates**: Projects get `updated_at` timestamp on new version

#### Understanding Analytics

**When analytics update:**
- ✅ When someone views project (Views +1)
- ✅ When someone downloads (Downloads +1)
- ✅ When someone comments (Comments +1)
- ✅ Tracked by username (or anonymous if not logged in)

**Viewing analytics:**
1. Open any project in details modal
2. Top section shows **three cards**:
   - Total Downloads
   - Total Views  
   - Total Comments

---

## 🔄 Workflow Examples

### Example 1: Upload a New Project with Versioning Support

**Initial Upload:**
1. Admin clicks "Upload Project"
2. Fills in project details
3. Publishes → Project created (Analytics record auto-created)
4. Becomes "Version 1 (Current)"

**Later: Bug Fix Update**
1. Admin opens project details
2. Fills in update description: "Fixed configuration syntax error"
3. Updates content with corrected files
4. Clicks "Publish New Version" → Version 2 created
5. Users can now select v1 or v2 to download

**Later: New Feature Update**
1. Admin adds new feature
2. Publishes as Version 3
3. Versions 1, 2, 3 all available
4. Download button defaults to Version 3

---

### Example 2: Community Engagement Flow

**Initial State:**
- Project created (0 downloads, 0 views, 0 comments)
- Analytics card shows: 0 | 0 | 0

**User A views project:**
- Clicks "View Details" → Views increment to 1
- Analytics shows: 0 | 1 | 0

**User A downloads:**
- Clicks "Download" → Downloads increment to 1
- Analytics shows: 1 | 1 | 0

**User B views & comments:**
- Opens details (Views: 2)
- Posts comment: "Great project!"
- Analytics shows: 1 | 2 | 1
- Comment appears with username, date, like count

**User B likes comment:**
- Clicks heart icon (future feature)
- Like counter increments

---

## 🔐 Security & Access Control

### RLS Policies

- **Public Read**: Anyone can view comments, versions, analytics
- **Public Write**: Anyone can post comments, track downloads
- **Admin Only**: Create versions (enforced in UI)
- **Logged In Only**: Post comments (enforced in JS)

### Data Privacy

- **Anonymous tracking**: Guests can download but username stored as `null`
- **User tracking**: Logged-in users tracked by username
- **No personal data**: Only username, timestamps, version numbers stored

---

## 🛠️ Technical Details

### Functions Added to index.html

#### Project Details
- `openProjectDetails(projectId)` - Open details modal
- `closeProjectDetailsModal()` - Close modal
- `loadProjectAnalytics(projectId)` - Load and display stats
- `loadProjectVersions(projectId)` - Load version history
- `loadProjectComments(projectId)` - Load comments

#### Interactions
- `postComment()` - Submit new comment
- `likeComment(commentId)` - Like a comment (foundation)
- `publishNewVersion()` - Create new version (admin)
- `downloadProjectVersion()` - Download with tracking

#### Auto-Triggered
- View tracking on modal open
- Download tracking on file download
- Analytics increment on all events
- Analytics record created on project upload

### API Endpoints Used

```javascript
// Get analytics
GET /project_analytics?project_id=eq.{id}

// Get versions
GET /project_versions?project_id=eq.{id}&order=version_number.desc

// Get comments
GET /project_comments?project_id=eq.{id}&order=created_at.desc

// Post comment
POST /project_comments
  { project_id, username, comment_text }

// Track download
POST /project_downloads
  { project_id, username, version_number }

// Track view
POST /project_views
  { project_id, username }

// Create version
POST /project_versions
  { project_id, version_number, content, description, created_by }

// Update project timestamp
PATCH /projects?id=eq.{id}
  { updated_at, content }

// Update analytics
PATCH /project_analytics?id=eq.{id}
  { total_downloads, total_views, total_comments }
```

---

## 📊 Feature Statistics

### What Gets Tracked

| Event | Stored In | Fields |
|-------|-----------|--------|
| View | project_views | project_id, username, viewed_at |
| Download | project_downloads | project_id, username, version_number, downloaded_at |
| Comment | project_comments | project_id, username, comment_text, likes |
| Version | project_versions | project_id, version_number, content, description |

### Analytics Aggregation

Stats are calculated in real-time from:
- **Downloads**: COUNT of rows in project_downloads
- **Views**: COUNT of rows in project_views
- **Comments**: COUNT of rows in project_comments

---

## 🎨 UI Components

### Project Details Modal
- **Header**: Project name, creator
- **Cover image**: Full-width project preview
- **Description**: Project content summary
- **Analytics**: 3-card stat display
- **Version selector**: Dropdown to choose version
- **Version notes**: Description of changes
- **Admin section**: Create new version form (conditional)
- **Comments**: Full discussion thread
- **Footer**: Download button + Close button

### Analytics Cards
- **Download count**: Total downloads all-time
- **View count**: Total views all-time
- **Comment count**: Total comments all-time
- **Color**: Brand accent (cyan)
- **Format**: Number + label

### Comments Section
- **Comment form**: Only shows if logged in
- **Comment list**: Sorted by newest first
- **Each comment shows**:
  - Username (brand-accent color)
  - Date posted (small text)
  - Comment text (main content)
  - Like counter with heart icon
- **Empty state**: "No comments yet" message

### Version Selector
- **Dropdown format**: Shows all versions
- **Latest marked**: "(Latest)" suffix on newest
- **Auto-select**: Latest selected by default
- **Change notes**: Display description below

---

## 🚨 Error Handling

### Graceful Fallbacks

- **No versions**: Shows "Version 1 (Current)"
- **No comments**: Shows empty state message
- **No analytics**: Shows 0 for all stats
- **Failed analytics update**: Non-critical (warning in console)

### User Messages

- ✅ "Comment posted!" - Success feedback
- ✅ "Version X published!" - Admin success
- ✅ "Downloaded: filename.txt" - Download success
- ❌ "Please sign in to comment" - Not logged in
- ❌ "Error posting comment" - API error
- ❌ "Error publishing new version" - Admin error

---

## 🎯 Future Enhancements

### Rating System Integration
- Add star ratings to comments
- Calculate average_rating in analytics
- Filter/sort by rating

### Notification System
- Email on new comments
- Alert on new versions
- Trending project alerts

### Advanced Analytics
- Download trends (chart)
- Popular versions
- User engagement metrics
- Peak usage times

### Version Comparison
- Side-by-side version diffs
- What changed between versions
- Rollback functionality

### Comment Management
- Edit own comments
- Delete comments (admin)
- Comment moderation
- Threaded replies

---

## 📚 SQL Setup

Run this in your Supabase SQL Editor to create all tables:

```sql
-- Copy entire contents of supabase_setup.sql
-- Tables created: project_versions, project_comments, 
--                 project_downloads, project_analytics, project_views
```

Or run manually (see supabase_setup.sql for full SQL)

---

## 🆘 Troubleshooting

### Analytics Not Updating
- Clear browser cache (Ctrl+Shift+Delete)
- Check console for errors (F12)
- Verify tables exist in Supabase

### Comments Not Showing
- Refresh page
- Make sure you're logged in to post
- Check that project_comments table exists

### Version Selector Empty
- Project has no versions yet
- First version created on project upload
- Create new version as admin

### Download File Not Generated
- Check browser console for errors
- Verify you're signed in
- Try a different project

---

## 💡 Tips & Best Practices

1. **Regular Updates**: Publish new versions regularly
2. **Clear Descriptions**: Write detailed update notes
3. **Engage Community**: Respond to comments
4. **Monitor Analytics**: Watch download/view trends
5. **Version Numbering**: Keep incrementing (1, 2, 3...)
6. **Content Management**: Keep version content up-to-date

---

Generated: June 2026 | Mono Projects Platform v2.0
