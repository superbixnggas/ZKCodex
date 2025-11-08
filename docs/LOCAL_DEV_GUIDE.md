# ZKCodex Local Development Guide

## Quick Start untuk Developer

### 1. Setup Environment
```bash
# Clone repository
git clone <repository-url>
cd zkcodex

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env dengan credentials Anda
```

### 2. Start Local Supabase
```bash
# Start local Supabase (requires Docker)
supabase start

# View local services
supabase status
# Output: http://localhost:54321 (API)
#         http://localhost:54323 (Dashboard)
#         http://localhost:54324 (DB)
```

### 3. Test Backend Locally
```bash
# Test all backend services
./test_backend.sh all

# Or test specific components
./test_backend.sh quick  # Quick test
./test_backend.sh message  # Test message API only
```

### 4. Development Workflow

#### A. Database Changes
```bash
# Create migration
supabase migration new add_new_feature

# Apply migrations
supabase db reset

# View current schema
supabase db diff
```

#### B. Edge Functions Development
```bash
# Create new function
supabase functions new function_name

# Test function locally
supabase functions serve

# Deploy function
supabase functions deploy function_name --no-verify-jwt
```

#### C. Frontend Development
```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Common Development Tasks

### 1. Add New AI Mode
Edit `supabase/functions/message/index.ts`:
```typescript
// Tambahkan case baru
else if (mode === 'new_mode') {
    const responses = [
        "Your new mode response 1",
        "Your new mode response 2"
    ];
    ai_response = responses[Math.floor(Math.random() * responses.length)];
}
```

Update database constraint:
```sql
ALTER TABLE codex_entries DROP CONSTRAINT codex_entries_ai_mode_check;
ALTER TABLE codex_entries ADD CONSTRAINT codex_entries_ai_mode_check 
    CHECK (ai_mode IN ('oracle', 'analyzer', 'signal', 'new_mode'));
```

### 2. Add New API Endpoint
```bash
# Create new function
supabase functions new new_endpoint

# Implement di supabase/functions/new_endpoint/index.ts
```

### 3. Database Schema Changes
```bash
# Create migration
supabase migration new update_table_schema

# Edit migration file di migrations/
# Apply
supabase db reset
```

### 4. Environment-Specific Configuration
Create `.env.development`, `.env.staging`, `.env.production` untuk different environments.

## Debugging

### 1. View Function Logs
```bash
# View logs
supabase functions logs message
supabase functions logs verify

# Follow logs in real-time
supabase functions logs message --follow
```

### 2. Database Debugging
```sql
-- Connect to local database
psql 'postgresql://postgres:postgres@localhost:54324/postgres'

-- Check table structure
\d codex_entries

-- Check recent entries
SELECT * FROM codex_entries ORDER BY timestamp DESC LIMIT 10;
```

### 3. API Testing
```bash
# Test dengan curl
curl -X POST 'http://localhost:54321/functions/v1/message' \
  -H 'Authorization: Bearer [anon-key]' \
  -H 'Content-Type: application/json' \
  -d '{"user_input": "test", "mode": "oracle"}'
```

## Production Deployment

### 1. Build & Deploy
```bash
# Deploy edge functions
./deploy_backend.sh

# Deploy frontend
npm run build
# Upload dist/ folder ke hosting service
```

### 2. Environment Variables (Production)
Set di hosting platform:
- Vercel: Project Settings → Environment Variables
- Netlify: Site Settings → Environment Variables
- Heroku: Config Vars

### 3. Custom Domain
```bash
# Setup DNS records
# A record: your-domain.com → hosting-ip
# CNAME: www.your-domain.com → your-domain.com
```

## Troubleshooting

### Common Issues

1. **Supabase CLI not found**
   ```bash
   npm install -g supabase
   ```

2. **Docker not running**
   ```bash
   # Start Docker Desktop
   # Windows: Start Docker Desktop
   # macOS: Start Docker Desktop  
   # Linux: sudo systemctl start docker
   ```

3. **Port conflicts**
   ```bash
   # Use different ports
   supabase start --db-port 54325
   ```

4. **Permission errors**
   ```bash
   # Fix script permissions
   chmod +x test_backend.sh
   chmod +x deploy_backend.sh
   ```

5. **Environment variables not loading**
   ```bash
   # Check .env file location and content
   cat .env
   
   # Ensure .env is in correct directory
   ls -la .env
   ```

### Getting Help

1. **Supabase Documentation**: https://supabase.com/docs
2. **CLI Reference**: `supabase --help`
3. **Logs**: Check function logs di dashboard
4. **Local Issues**: Use `supabase status` to check services

## Project Structure
```
zkcodex/
├── supabase/
│   ├── functions/          # Edge functions
│   │   ├── message/
│   │   └── verify/
│   ├── migrations/         # Database migrations
│   └── tables/            # Table schemas
├── frontend/              # React application
│   ├── src/
│   └── public/
├── .env.example          # Environment template
├── test_backend.sh       # Testing script
├── deploy_backend.sh     # Deployment script
└── BACKEND_README.md     # Backend documentation
```

---

**Happy Coding! 🚀**

If you encounter any issues, check the troubleshooting section or consult the main BACKEND_README.md file.