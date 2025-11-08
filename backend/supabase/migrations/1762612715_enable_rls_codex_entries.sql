-- Migration: enable_rls_codex_entries
-- Created at: 1762612715


-- Enable RLS for codex_entries table
ALTER TABLE codex_entries ENABLE ROW LEVEL SECURITY;

-- Allow both anon and service_role to insert (for edge function)
CREATE POLICY "Allow edge function inserts" ON codex_entries
  FOR INSERT
  WITH CHECK (auth.role() IN ('anon', 'service_role'));

-- Allow anyone to read entries
CREATE POLICY "Allow read access" ON codex_entries
  FOR SELECT
  USING (true);

-- Allow updates for verification
CREATE POLICY "Allow verification updates" ON codex_entries
  FOR UPDATE
  USING (auth.role() IN ('anon', 'service_role'))
  WITH CHECK (auth.role() IN ('anon', 'service_role'));
;