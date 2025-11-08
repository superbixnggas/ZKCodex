# ZKCodex - Quick Setup untuk Developer

## 🚀 Setup dalam 5 Menit

### 1. Prerequisites
```bash
# Install Node.js (v16+)
# Install Git
# Install text editor (VS Code recommended)
```

### 2. Clone & Setup
```bash
# Clone repository
git clone <your-repo-url>
cd zkcodex

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env dengan credentials Anda
```

### 3. Test Backend
```bash
# Test apakah backend sudah jalan
npm run test:quick
```

### 4. Development
```bash
# Start development
npm run dev

# Test website
npm run test
```

## 📋 Backend Yang Sudah Siap

### ✅ Edge Functions
- **`/message`** - AI response + hash generation
- **`/verify`** - Hash verification

### ✅ Database
- **Table**: `codex_entries`
- **Schema**: Complete dengan RLS policies
- **Hash**: SHA-256 untuk verifikasi

### ✅ AI Modes
- **Oracle**: Prediktif, naratif
- **Analyzer**: Teknikal, data-driven  
- **Signal**: Cepat, sinyal pasar

## 🔧 Commands yang Bikin Mudah

```bash
# Testing
npm run test:quick    # Quick test
npm run test:message  # Test message API
npm run test:verify   # Test verify API

# Development
npm run dev           # Start development
npm run build         # Build untuk production
npm run status        # Show current status

# Deployment
npm run deploy        # Deploy ke production
npm run logs          # View function logs
```

## 🌐 URLs yang Udah Ada

- **Website**: https://0f87nsxg065v.space.minimax.io
- **Supabase**: https://lrisuodzyseyqhukqvjw.supabase.co
- **Message API**: https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/message
- **Verify API**: https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/verify

## 📚 Documentation Lengkap

- **[BACKEND_README.md](./BACKEND_README.md)** - Dokumentasi lengkap backend
- **[LOCAL_DEV_GUIDE.md](./LOCAL_DEV_GUIDE.md)** - Panduan development lokal
- **[package.json](./package.json)** - Scripts dan dependencies

## 🆘 Troubleshooting Cepat

### Backend Error?
```bash
npm run check:env
```

### API Not Working?
```bash
npm run test:message
```

### Want to see logs?
```bash
npm run logs
```

## 🎯 Next Steps untuk Developer

1. **Read documentation**: BACKEND_READMD.md
2. **Test everything**: `npm run test`
3. **Start developing**: `npm run dev`
4. **Deploy when ready**: `npm run deploy`

---

**Backend sudah 100% ready! 🎉**  
**Mulai develop sekarang! 🚀**