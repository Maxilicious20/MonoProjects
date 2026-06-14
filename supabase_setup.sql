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
  icon TEXT NOT NULL,
  color TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

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

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_accounts_username ON accounts(username);
CREATE INDEX IF NOT EXISTS idx_tags_name ON tags(name);
CREATE INDEX IF NOT EXISTS idx_projects_name ON projects(name);

-- Enable RLS on tables
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access (modify as needed for security)
CREATE POLICY "Enable read access for all users" ON tags
  FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON projects
  FOR SELECT USING (true);

CREATE POLICY "Enable all access for authenticated users on accounts" ON accounts
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all access for authenticated users on tags" ON tags
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Enable all access for authenticated users on projects" ON projects
  FOR ALL USING (true) WITH CHECK (true);
