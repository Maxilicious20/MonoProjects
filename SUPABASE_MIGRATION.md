# Supabase Migration Guide

## Changes Made

Your Mono Projects application has been successfully migrated from Firebase Firestore to **Supabase PostgreSQL**.

### Key Changes:

1. **Database**: Firebase Firestore → Supabase PostgreSQL (via PostgREST API)
2. **Authentication**: Firebase Auth → Custom table-based authentication using Supabase
3. **API Calls**: All Firestore operations replaced with Supabase PostgREST REST API calls

### What Was Changed in `index.html`:

- Removed Firebase SDK imports
- Added Supabase configuration (URL and API key)
- Created `supabaseRequest()` helper function to handle all API calls
- Updated authentication logic to query `accounts` table instead of Firebase Auth
- Updated all CRUD operations:
  - **Tags**: Now stored in `tags` table
  - **Projects**: Now stored in `projects` table
  - **Accounts**: Now stored in `accounts` table
- Updated field names to match PostgreSQL naming conventions:
  - `isAdmin` → `is_admin`
  - `imageUrl` → `image_url`
  - `isPro` → `is_pro`
  - `createdAt` → `created_at`
  - `updatedAt` → `updated_at`

## Setup Instructions

### Step 1: Create Tables in Supabase

1. Go to your Supabase project dashboard: https://app.supabase.com
2. Navigate to the **SQL Editor** section
3. Create a new query
4. Copy the contents of `supabase_setup.sql` and paste it into the editor
5. Click **Run** to execute the SQL migrations

This will create three tables:
- `accounts` - User account storage
- `tags` - Dynamic AI model/feature tags
- `projects` - AI project listings

### Step 2: Verify Configuration

The application is already configured with your Supabase credentials:

- **URL**: `https://tbrbazbrisyufuxhtgws.supabase.co`
- **Anon Key**: Pre-configured in `index.html`

### Step 3: Test the Application

1. Open `index.html` in your browser
2. Click **Sign In** and create a new account
3. To access admin features, create an account with username: `Maxilicious20`
4. Use admin panel to:
   - Create dynamic tags
   - Upload AI projects
   - Manage project metadata

## Row Level Security (RLS)

The SQL setup includes basic RLS policies that allow:
- Public read access to `tags` and `projects`
- Full access to `accounts` table (for authentication flow)

**⚠️ Security Note**: For production, you should:
1. Implement proper authentication using Supabase Auth
2. Add more restrictive RLS policies
3. Use environment variables for API keys instead of hardcoding

## Database Schema

### accounts table
```
id (UUID) - Primary key
username (TEXT) - Unique username
password (TEXT) - User password (consider hashing in production)
is_admin (BOOLEAN) - Admin flag
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### tags table
```
id (TEXT) - Primary key (auto-generated ID)
name (TEXT) - Tag name (unique)
icon (TEXT) - FontAwesome icon class
color (TEXT) - Color theme (cyan, indigo, emerald, etc.)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

### projects table
```
id (TEXT) - Primary key (auto-generated ID)
name (TEXT) - Project name
image_url (TEXT) - Cover image URL
tags (TEXT[]) - Array of tag names
is_pro (BOOLEAN) - Pro deployment flag
updated_at (TEXT) - Last update date
content (TEXT) - Project configuration/content
created_by (TEXT) - Username who created the project
created_at (TIMESTAMP)
```

## Troubleshooting

### "Database connectivity issues" Error
- Verify Supabase URL and API key are correct
- Check that tables were created successfully in Supabase
- Ensure RLS policies are enabled on tables

### Admin Features Not Appearing
- Create an account with username: `Maxilicious20` (case-sensitive)
- You need to sign in with this account to access admin panels

### Tags Not Loading
- Check browser console for errors
- Verify tables exist in Supabase SQL Editor
- Try refreshing the page

## Next Steps

Consider these improvements for production:

1. **Implement Supabase Auth**: Replace simple password storage with Supabase Auth for security
2. **Add proper encryption**: Hash passwords using bcrypt
3. **Implement proper RLS**: Add user-specific policies
4. **Add file storage**: Use Supabase Storage for project files
5. **Add API authentication**: Use environment variables and API key rotation
6. **Enable HTTPS**: Ensure all connections are secure

## Support

For issues with Supabase, visit: https://supabase.com/docs
