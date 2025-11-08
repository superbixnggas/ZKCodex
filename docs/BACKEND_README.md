# ZKCodex Backend Documentation

## Overview
ZKCodex menggunakan **Supabase** sebagai backend dengan dua edge functions utama dan database PostgreSQL untuk sistem Zero-Knowledge Transmission.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │  Edge Functions │    │  PostgreSQL     │
│  (React/Vite)   │───▶│   (Deno)        │───▶│   Database      │
│                 │    │                 │    │                 │
│ • Chat UI       │    │ • /message      │    │ • codex_entries │
│ • File Explorer │    │ • /verify       │    │ • Hash Ledger   │
│ • AI Modes      │    │ • AI Response   │    │ • Verification  │
│ • Hash System   │    │ • SHA-256 Hash  │    │ • RLS Policies  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Backend Components

### 1. Database Schema (`codex_entries`)

```sql
CREATE TABLE codex_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_input TEXT NOT NULL,
    ai_mode TEXT NOT NULL CHECK (ai_mode IN ('oracle', 'analyzer', 'signal')),
    ai_response TEXT NOT NULL,
    codex_hash TEXT NOT NULL UNIQUE,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    verified BOOLEAN DEFAULT false
);
```

**Fields Description:**
- `id`: Unique identifier (UUID)
- `user_input`: User's message input
- `ai_mode`: Response mode (oracle/analyzer/signal)
- `ai_response`: Generated AI response
- `codex_hash`: SHA-256 hash for verification
- `timestamp`: Creation timestamp
- `verified`: Hash verification status

### 2. Edge Functions

#### A. `/message` - AI Response & Hash Generation
- **Endpoint**: `POST /functions/v1/message`
- **Purpose**: Generate AI response and create codex hash
- **Request Body**:
  ```json
  {
    "user_input": "string",
    "mode": "oracle|analyzer|signal"
  }
  ```
- **Response**:
  ```json
  {
    "data": {
      "response": "AI generated response",
      "codex_hash": "sha256_hash_string",
      "timestamp": "2025-11-09T04:09:58.000Z",
      "entry": { "id": "uuid", "verified": false }
    }
  }
  ```

**AI Response Modes:**
- **Oracle**: Prediktif, naratif, entitas masa depan
- **Analyzer**: Teknikal, data-driven dengan metrics
- **Signal**: Cepat, instingtif untuk sinyal pasar

**Hash Algorithm:**
```
codex_hash = SHA-256(timestamp + user_input + ai_response + service_role_key)
```

#### B. `/verify` - Hash Verification
- **Endpoint**: `GET /functions/v1/verify?hash={codex_hash}`
- **Purpose**: Verify hash existence and authenticity
- **Response**:
  ```json
  {
    "data": {
      "status": "verified|invalid",
      "timestamp": "creation_time",
      "ai_mode": "mode",
      "message": "verification_message"
    }
  }
  ```

## Environment Variables

Buat file `.env` di root project:

```env
# Supabase Configuration
SUPABASE_URL=https://lrisuodzyseyqhukqvjw.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxyaXN1b2R6eXNleXFodWtxdmp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1NjY2NjcsImV4cCI6MjA3ODE0MjY2N30.DRA4jM6TnkHv04g2WqXdnoM0XhwKD7OI6tl6hZlPviA
SUPABASE_SERVICE_ROLE_KEY=[ASK_SUPABASE_FOR_THIS]

# Development
NODE_ENV=development
```

**⚠️ SECURITY WARNING:**
- `SUPABASE_SERVICE_ROLE_KEY` adalah secret key yang sangat sensitif
- **JANGAN** push ke repository
- Hanya gunakan di backend/server environment
- Key ini bisa bypass RLS (Row Level Security)

## Installation & Setup

### 1. Prerequisites
```bash
# Install Supabase CLI
npm install -g supabase

# Login ke Supabase
supabase login

# Clone dan setup project
git clone <your-repo>
cd zkcodex
npm install
```

### 2. Supabase Configuration
```bash
# Link ke project existing
supabase link --project-ref lrisuodzyseyqhukqvjw

# Deploy edge functions
supabase functions deploy message
supabase functions deploy verify

# Run database migrations
supabase db reset  # untuk local development
```

### 3. Local Development
```bash
# Start local Supabase
supabase start

# Copy environment variables
cp .env.example .env.local

# Start development server
npm run dev

# Test edge functions locally
curl -X POST 'http://localhost:54321/functions/v1/message' \
  -H 'Authorization: Bearer [anon-key]' \
  -H 'Content-Type: application/json' \
  -d '{"user_input": "test", "mode": "oracle"}'
```

## Database Setup (for Developer)

### RLS (Row Level Security) Policies
```sql
-- Enable RLS pada table
ALTER TABLE codex_entries ENABLE ROW LEVEL SECURITY;

-- Policy untuk anonymous access (needed for edge functions)
CREATE POLICY "Enable read access for all users" ON codex_entries
  FOR SELECT USING (true);

CREATE POLICY "Enable insert for all users" ON codex_entries
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update for all users" ON codex_entries
  FOR UPDATE USING (true);
```

### Migration Files
Gunakan file yang sudah ada di `supabase/migrations/` untuk setup database.

## API Testing

### Test Message API
```bash
curl -X POST 'https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/message' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
    "user_input": "test message",
    "mode": "oracle"
  }'
```

### Test Verify API
```bash
curl 'https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/verify?hash=your_hash_here'
```

## Security Best Practices

### 1. Environment Variables
- ✅ Gunakan `.env` untuk local development
- ❌ **JANGAN** commit `.env` ke git
- ❌ **JANGAN** expose `SERVICE_ROLE_KEY` di frontend

### 2. CORS Configuration
Edge functions sudah configured untuk:
- Allow all origins untuk development
- Specific origins untuk production

### 3. Input Validation
- User input validation di edge functions
- SQL injection prevention dengan parameterized queries
- XSS prevention dengan proper escaping

## Troubleshooting

### Common Issues

1. **"Konfigurasi Supabase tidak ditemukan"**
   ```bash
   # Check environment variables
   echo $SUPABASE_URL
   echo $SUPABASE_SERVICE_ROLE_KEY
   ```

2. **"RLS Policy Error"**
   ```sql
   -- Check RLS status
   SELECT tablename, rowsecurity FROM pg_tables 
   WHERE tablename = 'codex_entries';
   ```

3. **Edge Functions Deployment Error**
   ```bash
   # Redeploy functions
   supabase functions deploy message --no-verify-jwt
   supabase functions deploy verify --no-verify-jwt
   ```

4. **Database Connection Error**
   ```bash
   # Check Supabase project status
   supabase status
   ```

## Production Deployment

### 1. Build & Deploy
```bash
# Build frontend
npm run build

# Deploy ke Vercel/Netlify
vercel deploy --prod
# atau
netlify deploy --prod --dir=dist
```

### 2. Environment Variables (Production)
Set di hosting platform (Vercel, Netlify):
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

### 3. Custom Domain (Optional)
```bash
# Setup custom domain di hosting platform
# Configure CNAME/A records
# Update CORS headers di edge functions
```

## Monitoring & Logs

### Supabase Dashboard
- **Logs**: Functions → Logs
- **Database**: Table Editor, SQL Editor
- **API**: Settings → API

### Health Check
```bash
# Check if services are running
curl 'https://lrisuodzyseyqhukqvjw.supabase.co/rest/v1/codex_entries?select=count'
```

## Support

Jika ada masalah dengan backend:
1. Check Supabase dashboard logs
2. Verify environment variables
3. Test edge functions via curl
4. Check RLS policies
5. Consult troubleshooting section di atas

---

**Author**: MiniMax Agent  
**Last Updated**: 2025-11-09  
**Version**: 1.0.0