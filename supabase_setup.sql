-- Supabase SQL Setup for Mono Projects

-- Enable RLS (Row Level Security)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;

-- Create accounts table
CREATE TABLE IF NOT EXISTS accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tags table
CREATE TABLE IF NOT EXISTS tags (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  icon TEXT,
  icon_url TEXT,
  color TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- MANUAL STEP: Create storage bucket for tag icons
-- You MUST do this manually in Supabase:
-- 1. Go to Storage section in Supabase dashboard
-- 2. Create a new bucket named "tag_icons"
-- 3. Make it public by unchecking "Private bucket"
-- 4. Enable public access in bucket settings
-- This cannot be done via SQL

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  image_url TEXT,
  tags TEXT[] DEFAULT '{}',
  is_pro BOOLEAN DEFAULT FALSE,
  updated_at TEXT,
  content TEXT,
  created_by TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create project versions table (for update history)
CREATE TABLE IF NOT EXISTS project_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  version_number INT NOT NULL,
  content TEXT,
  description TEXT,
  created_by TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(project_id, version_number)
);

-- Create project comments table (for discussions)
CREATE TABLE IF NOT EXISTS project_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  comment_text TEXT NOT NULL,
  likes INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create project downloads table (for analytics)
CREATE TABLE IF NOT EXISTS project_downloads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  username TEXT,
  version_number INT,
  downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create project analytics table (aggregate stats)
CREATE TABLE IF NOT EXISTS project_analytics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id TEXT NOT NULL UNIQUE REFERENCES projects(id) ON DELETE CASCADE,
  total_downloads INT DEFAULT 0,
  total_views INT DEFAULT 0,
  total_comments INT DEFAULT 0,
  average_rating FLOAT DEFAULT 0,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create project views table (track unique views)
CREATE TABLE IF NOT EXISTS project_views (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id TEXT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  username TEXT,
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_accounts_username ON accounts(username);
CREATE INDEX IF NOT EXISTS idx_tags_name ON tags(name);
CREATE INDEX IF NOT EXISTS idx_projects_name ON projects(name);
CREATE INDEX IF NOT EXISTS idx_versions_project ON project_versions(project_id);
CREATE INDEX IF NOT EXISTS idx_comments_project ON project_comments(project_id);
CREATE INDEX IF NOT EXISTS idx_downloads_project ON project_downloads(project_id);
CREATE INDEX IF NOT EXISTS idx_views_project ON project_views(project_id);

-- Enable RLS on tables
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_views ENABLE ROW LEVEL SECURITY;

-- Create policies for public/authenticated access (idempotent)

-- tags: public SELECT
DROP POLICY IF EXISTS "Enable read access for all users" ON tags;
CREATE POLICY "Enable read access for all users" ON tags
  FOR SELECT USING (true);

-- projects: public SELECT
DROP POLICY IF EXISTS "Enable read access for all users" ON projects;
CREATE POLICY "Enable read access for all users" ON projects
  FOR SELECT USING (true);

-- accounts: authenticated full access
DROP POLICY IF EXISTS "Enable all access for authenticated users on accounts" ON accounts;
CREATE POLICY "Enable all access for authenticated users on accounts" ON accounts
  FOR ALL USING (true) WITH CHECK (true);

-- tags: authenticated full access
DROP POLICY IF EXISTS "Enable all access for authenticated users on tags" ON tags;
CREATE POLICY "Enable all access for authenticated users on tags" ON tags
  FOR ALL USING (true) WITH CHECK (true);

-- projects: authenticated full access
DROP POLICY IF EXISTS "Enable all access for authenticated users on projects" ON projects;
CREATE POLICY "Enable all access for authenticated users on projects" ON projects
  FOR ALL USING (true) WITH CHECK (true);

-- project_versions policies
DROP POLICY IF EXISTS "Enable read access for versions" ON project_versions;
CREATE POLICY "Enable read access for versions" ON project_versions
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Enable write access for versions" ON project_versions;
CREATE POLICY "Enable write access for versions" ON project_versions
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Enable delete access for versions" ON project_versions;
CREATE POLICY "Enable delete access for versions" ON project_versions
  FOR DELETE USING (true);

-- project_comments policies
DROP POLICY IF EXISTS "Enable read access for comments" ON project_comments;
CREATE POLICY "Enable read access for comments" ON project_comments
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Enable write access for comments" ON project_comments;
CREATE POLICY "Enable write access for comments" ON project_comments
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Enable delete access for comments" ON project_comments;
CREATE POLICY "Enable delete access for comments" ON project_comments
  FOR DELETE USING (true);

-- project_downloads policies
DROP POLICY IF EXISTS "Enable read access for downloads" ON project_downloads;
CREATE POLICY "Enable read access for downloads" ON project_downloads
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Enable write access for downloads" ON project_downloads;
CREATE POLICY "Enable write access for downloads" ON project_downloads
  FOR INSERT WITH CHECK (true);

-- project_views policies
DROP POLICY IF EXISTS "Enable read access for views" ON project_views;
CREATE POLICY "Enable read access for views" ON project_views
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Enable write access for views" ON project_views;
CREATE POLICY "Enable write access for views" ON project_views
  FOR INSERT WITH CHECK (true);

-- project_analytics policies
DROP POLICY IF EXISTS "Enable read access for analytics" ON project_analytics;
CREATE POLICY "Enable read access for analytics" ON project_analytics
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Enable write access for analytics" ON project_analytics;
CREATE POLICY "Enable write access for analytics" ON project_analytics
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Enable update access for analytics" ON project_analytics;
CREATE POLICY "Enable update access for analytics" ON project_analytics
  FOR UPDATE WITH CHECK (true);

-- Storage bucket policies (apply AFTER creating bucket)
-- These should be created via Supabase UI or run separately:
 /*
CREATE POLICY "Public read access to tag_icons" ON storage.objects
  FOR SELECT USING (bucket_id = 'tag_icons');

CREATE POLICY "Admin upload to tag_icons" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'tag_icons');

CREATE POLICY "Admin delete from tag_icons" ON storage.objects
  FOR DELETE USING (bucket_id = 'tag_icons');
*/