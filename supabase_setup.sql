-- ============================================
-- ATHLETICA SUPABASE DATABASE SETUP
-- ============================================
-- Run this entire script in Supabase SQL Editor
-- ============================================

-- ============================================
-- CREATE TABLES
-- ============================================

-- Coaches table
CREATE TABLE IF NOT EXISTS coaches (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  profile_photo_url TEXT,
  bio TEXT,
  certificates TEXT[],
  subscription_tier TEXT DEFAULT 'free',
  client_limit INTEGER DEFAULT 3,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_active TIMESTAMPTZ,
  settings JSONB DEFAULT '{}'
);

-- Clients table
CREATE TABLE IF NOT EXISTS clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  profile_photo_url TEXT,
  status TEXT DEFAULT 'pending',
  subscription_progress DOUBLE PRECISION DEFAULT 0.0,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  last_session TIMESTAMPTZ,
  goals JSONB DEFAULT '{}',
  stats JSONB DEFAULT '{}',
  session_history JSONB DEFAULT '[]'
);

-- Plans table
CREATE TABLE IF NOT EXISTS plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  duration INTEGER NOT NULL,
  price DOUBLE PRECISION NOT NULL,
  features TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active',
  client_count INTEGER DEFAULT 0,
  success_rate DOUBLE PRECISION DEFAULT 0.0,
  revenue DOUBLE PRECISION DEFAULT 0.0
);

-- ============================================
-- CREATE INDEXES (for better performance)
-- ============================================

CREATE INDEX IF NOT EXISTS idx_clients_coach_id ON clients(coach_id);
CREATE INDEX IF NOT EXISTS idx_plans_coach_id ON plans(coach_id);
CREATE INDEX IF NOT EXISTS idx_clients_status ON clients(status);
CREATE INDEX IF NOT EXISTS idx_plans_status ON plans(status);

-- ============================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================

ALTER TABLE coaches ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;

-- ============================================
-- CREATE RLS POLICIES
-- ============================================

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Coaches can view own profile" ON coaches;
DROP POLICY IF EXISTS "Coaches can update own profile" ON coaches;
DROP POLICY IF EXISTS "Coaches can insert own profile" ON coaches;
DROP POLICY IF EXISTS "Coaches can manage own clients" ON clients;
DROP POLICY IF EXISTS "Coaches can manage own plans" ON plans;

-- Coaches can view their own profile
CREATE POLICY "Coaches can view own profile" ON coaches
  FOR SELECT USING (auth.uid() = id);

-- Coaches can update their own profile
CREATE POLICY "Coaches can update own profile" ON coaches
  FOR UPDATE USING (auth.uid() = id);

-- Coaches can insert their own profile (for signup)
CREATE POLICY "Coaches can insert own profile" ON coaches
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Coaches can manage their own clients (all operations)
CREATE POLICY "Coaches can manage own clients" ON clients
  FOR ALL USING (auth.uid() = coach_id);

-- Coaches can manage their own plans (all operations)
CREATE POLICY "Coaches can manage own plans" ON plans
  FOR ALL USING (auth.uid() = coach_id);

-- ============================================
-- VERIFICATION QUERY
-- ============================================
-- Run this to verify tables were created:
-- SELECT table_name 
-- FROM information_schema.tables 
-- WHERE table_schema = 'public' 
--   AND table_name IN ('coaches', 'clients', 'plans')
-- ORDER BY table_name;

