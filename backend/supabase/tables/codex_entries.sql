CREATE TABLE codex_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_input TEXT NOT NULL,
    ai_mode TEXT NOT NULL CHECK (ai_mode IN ('oracle',
    'analyzer',
    'signal')),
    ai_response TEXT NOT NULL,
    codex_hash TEXT NOT NULL UNIQUE,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    verified BOOLEAN DEFAULT false
);