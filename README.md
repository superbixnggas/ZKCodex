# 🔮 ZKCodex - Crypto Trading Analysis System

[![Deploy Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen)](https://f30gia3n7psl.space.minimax.io)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Node](https://img.shields.io/badge/Node-16%2B-green.svg)](https://nodejs.org)
[![Supabase](https://img.shields.io/badge/Supabase-Ready-purple.svg)](https://supabase.com)

ZKCodex adalah sistem komunikasi AI untuk **analisis crypto trading real-time** yang menggunakan teknologi Zero-Knowledge Transmission untuk verifikasi keaslian data.

## 🚀 Live Demo

**Website Production**: [https://f30gia3n7psl.space.minimax.io](https://f30gia3n7psl.space.minimax.io)

### Features:
- 🔮 **Oracle Mode**: Prediksi arah market Solana berdasarkan data real-time
- ⚙️ **Analyzer Mode**: Analisis teknikal dengan volume, RSI, dan sentiment
- ⚡ **Signal Mode**: Alert real-time untuk volume spike dan momentum

## 📊 Real-time Crypto Data

Integrasi API eksternal untuk data real-time:
- **CoinGecko API**: Solana price data (updated setiap saat)
- **DexScreener API**: Volume, transactions, trading pairs
- **Zero-Knowledge Hash**: Verifikasi keaslian setiap transmisi

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │  Edge Functions │    │  PostgreSQL     │
│  (Static HTML)  │───▶│   (Deno)        │───▶│   Database      │
│                 │    │                 │    │                 │
│ • Chat UI       │    │ • /message      │    │ • codex_entries │
│ • AI Modes      │    │ • /verify       │    │ • Hash Ledger   │
│ • Real-time     │    │ • CoinGecko     │    │ • Verification  │
│ • Hash System   │    │ • DexScreener   │    │ • RLS Policies  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## ⚡ Quick Start

### 1. Prerequisites
```bash
# Install Node.js (v16+)
# Install Git
# Install Supabase CLI: npm install -g supabase
```

### 2. Clone & Setup
```bash
# Clone repository
git clone <your-repo-url>
cd zkcodex-crypto-trading-analysis

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env dengan credentials Anda
```

### 3. Start Development
```bash
# Start development server
npm run dev

# Test backend services
npm run test:quick

# Test frontend
npm run test:frontend
```

## 📁 Project Structure

```
zkcodex-crypto-trading-analysis/
├── frontend/                 # Static HTML frontend
│   └── index.html           # Main application
├── backend/                  # Supabase backend
│   ├── supabase/            # Supabase configuration
│   │   ├── functions/       # Edge functions
│   │   │   ├── message/     # AI response + crypto API
│   │   │   └── verify/      # Hash verification
│   │   ├── migrations/      # Database migrations
│   │   └── tables/         # Table schemas
├── docs/                     # Documentation
│   ├── BACKEND_README.md    # Backend documentation
│   ├── LOCAL_DEV_GUIDE.md   # Development guide
│   ├── QUICK_START.md       # Quick setup guide
│   ├── CRYPTO_TRADING_ANALYSIS_DOCS.md
│   ├── FINAL_TESTING_REPORT.md
│   └── TESTING_SUMMARY.md
├── scripts/                  # Development scripts
│   ├── test_backend.sh      # Backend testing
│   ├── test_website.sh      # Frontend testing
│   └── deploy_backend.sh    # Deployment script
├── package.json              # Node.js configuration
├── .env.example             # Environment template
└── .gitignore              # Git ignore rules
```

## 🔧 Development Commands

### Testing
```bash
# Test all backend services
npm run test

# Test backend only
npm run test:quick
npm run test:message
npm run test:verify

# Test frontend
npm run test:frontend
```

### Development
```bash
# Start development
npm run dev                    # Frontend only
npm run dev:backend           # Backend only
npm run dev:all               # Both frontend and backend

# Database
npm run reset:db              # Reset local database
npm run deploy:db             # Deploy migrations

# Functions
npm run deploy:functions      # Deploy edge functions
npm run logs                  # View function logs
```

### Production
```bash
# Deploy everything
npm run deploy

# Health check
npm run health:check
npm run status
```

## 🌍 Environment Variables

Buat file `.env` di root project:

```env
# Supabase Configuration
SUPABASE_URL=https://lrisuodzyseyqhukqvjw.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=[ASK_ADMIN_FOR_THIS]

# Development
NODE_ENV=development
VITE_SUPABASE_URL=$SUPABASE_URL
VITE_SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

**⚠️ SECURITY WARNING:**
- `SUPABASE_SERVICE_ROLE_KEY` adalah secret key yang sangat sensitif
- **JANGAN** push ke repository
- Hanya gunakan di backend/server environment
- Key ini bisa bypass RLS (Row Level Security)

## 🤖 AI Modes

### 🔮 Oracle Mode
**Fungsi**: Market prediction dan trend analysis

**API Integrations**:
- CoinGecko: Real-time Solana price data
- DexScreener: Volume dan transaction data

**Response Format**:
```
📈 Solana saat ini $157.72 (-3.0%). 
Prediksi: DOWNTREND 4h | Target: $153.92-152.01 | Confidence: 79%
```

**Features**:
- ✅ Real-time price tracking
- ✅ Trend prediction algorithm
- ✅ Target price calculation
- ✅ Confidence scoring (0-100%)

### ⚙️ Analyzer Mode
**Fungsi**: Technical analysis dengan metrics lengkap

**API Integrations**:
- DexScreener: Trading pairs dan volume data
- CoinGecko: Market data dan sentiment

**Response Format**:
```
📊 Solana volume: $0.16B (24h). Txns: 49,818. 
Trend: STRONG DOWNTREND. RSI: 44 (Neutral)
```

**Features**:
- ✅ Volume analysis (24h, 7d, 30d)
- ✅ Transaction count tracking
- ✅ RSI calculation dan interpretation
- ✅ Market sentiment analysis
- ✅ Technical indicators

### ⚡ Signal Mode
**Fungsi**: Real-time alerts dan action recommendations

**API Integrations**:
- DexScreener: Volume spikes dan price movements
- CoinGecko: Price momentum data

**Response Format**:
```
⚡ ALERT: Volume spike 81% | Price momentum: BUILDING 
Action: HOLD $157.72 | RSI: 44
```

**Features**:
- ✅ Volume spike detection (>50% increase)
- ✅ Price momentum analysis
- ✅ Action recommendations (BUY/HOLD/SELL)
- ✅ Risk level assessment
- ✅ Real-time alerts

## 🔐 Zero-Knowledge System

### Hash Generation
```
codex_hash = SHA-256(timestamp + user_input + ai_response + service_role_key)
```

### Verification Process
1. User send message
2. System generate AI response
3. Create unique codex_hash
4. Store di database dengan verified=false
5. User can verify hash authenticity

### Database Schema
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

## 📈 API Integration

### CoinGecko API
- **URL**: `https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd`
- **Rate Limit**: 50 calls/minute
- **Data**: Real-time Solana price, market cap, volume
- **Cache**: 5 minutes untuk optimize performance

### DexScreener API
- **URL**: `https://api.dexscreener.com/latest/dex/pairs/solana`
- **Rate Limit**: 300 calls/minute
- **Data**: Trading pairs, volume, transactions, liquidity
- **Cache**: 2 minutes untuk real-time accuracy

## 🛠️ Backend Development

### Edge Functions

#### `/message` - AI Response Generation
- **Endpoint**: `POST /functions/v1/message`
- **Input**: `{"user_input": "string", "mode": "oracle|analyzer|signal"}`
- **Output**: `{"response": "ai_response", "codex_hash": "hash", "timestamp": "iso"}`

#### `/verify` - Hash Verification
- **Endpoint**: `GET /functions/v1/verify?hash={codex_hash}`
- **Output**: `{"status": "verified|invalid", "message": "verification_result"}`

### Database
- **Supabase PostgreSQL** dengan RLS policies
- **Row Level Security** untuk data protection
- **Real-time subscriptions** untuk live updates

## 🧪 Testing

### Backend Testing
```bash
# Test all APIs
curl -X POST 'https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/message' \
  -H 'Authorization: Bearer [anon-key]' \
  -H 'Content-Type: application/json' \
  -d '{"user_input": "test", "mode": "oracle"}'

# Test hash verification
curl 'https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/verify?hash=[hash]'
```

### Automated Testing
```bash
# Run all tests
./scripts/test_backend.sh all

# Test specific components
./scripts/test_backend.sh message
./scripts/test_backend.sh verify
./scripts/test_website.sh
```

## 🚀 Deployment

### Frontend (Static)
- **Current**: Deployed ke MiniMax Space
- **URL**: https://f30gia3n7psl.space.minimax.io
- **Method**: Static HTML + CDN

### Backend (Supabase)
- **Platform**: Supabase Edge Functions
- **Region**: US East 1
- **Scaling**: Automatic
- **Monitoring**: Supabase Dashboard

### Custom Domain (Optional)
1. Setup DNS records di hosting provider
2. Configure SSL certificates
3. Update CORS headers di edge functions

## 📚 Documentation

- **[Backend Documentation](docs/BACKEND_README.md)** - Comprehensive backend guide
- **[Local Development](docs/LOCAL_DEV_GUIDE.md)** - Development setup guide
- **[Quick Start](docs/QUICK_START.md)** - 5-minute setup guide
- **[Crypto Analysis Features](docs/CRYPTO_TRADING_ANALYSIS_DOCS.md)** - Feature documentation
- **[Testing Report](docs/FINAL_TESTING_REPORT.md)** - Comprehensive test results

## 🐛 Troubleshooting

### Common Issues

1. **"Konfigurasi Supabase tidak ditemukan"**
   ```bash
   npm run check:env
   # Pastikan semua environment variables ter-set
   ```

2. **Edge Functions Deployment Error**
   ```bash
   supabase functions deploy message --no-verify-jwt
   supabase functions deploy verify --no-verify-jwt
   ```

3. **Database Connection Error**
   ```bash
   supabase status
   # Check if local Supabase is running
   ```

4. **API Rate Limiting**
   - CoinGecko: 50 calls/minute (handled dengan caching)
   - DexScreener: 300 calls/minute (handled dengan caching)
   - Graceful degradation jika API down

### Getting Help

1. Check Supabase dashboard logs
2. Run health check: `npm run health:check`
3. View function logs: `npm run logs`
4. Check testing reports in `/docs/`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Roadmap

- [ ] **Multi-Token Support**: BTC, ETH, ADA analysis
- [ ] **Advanced Indicators**: MACD, Bollinger Bands, SMA/EMA
- [ ] **Portfolio Tracking**: Multi-wallet integration
- [ ] **Real-time Charts**: TradingView integration
- [ ] **Mobile App**: React Native version
- [ ] **API Keys**: User-specific API integrations
- [ ] **Alerts System**: Telegram/Discord notifications

## 📞 Support

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/your-username/zkcodex-crypto-analysis/issues)
- **Email**: support@zkcodex.com
- **Discord**: [Join our community](https://discord.gg/zkcodex)

---

**Built with ❤️ by MiniMax Agent**

*ZKCodex - Zero-Knowledge Crypto Trading Analysis*