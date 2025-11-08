# 📝 Contributing to ZKCodex

Terima kasih atas minat Anda untuk berkontribusi pada ZKCodex! Dokumen ini memberikan panduan untuk developer yang ingin berkontribusi pada proyek crypto trading analysis system ini.

## 🎯 Project Overview

ZKCodex adalah sistem AI untuk analisis crypto trading real-time dengan fitur Zero-Knowledge Verification. Proyek ini menggunakan:
- **Frontend**: Static HTML + Tailwind CSS
- **Backend**: Supabase Edge Functions (Deno)
- **Database**: PostgreSQL dengan RLS
- **APIs**: CoinGecko, DexScreener untuk data real-time

## 🚀 Getting Started

### 1. Prerequisites
- Node.js 16+ 
- Git
- Supabase CLI: `npm install -g supabase`
- Code editor (VS Code recommended)

### 2. Local Development Setup
```bash
# Clone repository
git clone <your-repo-url>
cd zkcodex-crypto-trading-analysis

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env dengan credentials Anda

# Start development
npm run dev
```

### 3. Verify Setup
```bash
# Check environment variables
npm run check:env

# Run tests
npm run test:quick
```

## 🔧 Development Workflow

### Branch Strategy
```bash
# Main development
main                    # Production-ready code
├── develop             # Development branch
├── feature/*           # New features
├── bugfix/*           # Bug fixes
├── hotfix/*           # Critical fixes
└── documentation/*    # Docs updates
```

### Code Style
- **JavaScript**: Use modern ES6+ features
- **HTML**: Semantic markup, accessibility focus
- **CSS**: Tailwind CSS for styling
- **Documentation**: Markdown format

### Commit Convention
```bash
# Format: type(scope): description

feat(frontend): add new AI mode
fix(backend): resolve API timeout issue
docs(README): update installation guide
test(API): add crypto API integration tests
refactor(database): optimize query performance
```

## 🏗️ Adding New Features

### 1. New AI Mode
```typescript
// Add to backend/supabase/functions/message/index.ts
else if (mode === 'new_mode') {
    // Implement your new mode logic
    // Call external APIs
    // Generate appropriate response
    ai_response = "Your response here";
}
```

### 2. New API Integration
```typescript
// Add to backend/supabase/functions/message/index.ts
const externalApiData = await fetch('https://your-api.com/data');
const data = await externalApiData.json();
// Process and include in response
```

### 3. Database Changes
```bash
# Create migration
supabase migration new add_new_feature

# Edit migration file
# Apply to local DB
supabase db reset
```

## 🧪 Testing Guidelines

### Backend Testing
```bash
# Test edge functions
npm run test:message
npm run test:verify

# Test specific mode
./scripts/test_backend.sh message
```

### Frontend Testing
```bash
# Test UI functionality
npm run test:frontend

# Manual testing
# 1. Open browser dev tools
# 2. Test all AI modes
# 3. Verify hash generation
# 4. Check console for errors
```

### API Testing
```bash
# Test with curl
curl -X POST 'https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/message' \
  -H 'Authorization: Bearer [anon-key]' \
  -H 'Content-Type: application/json' \
  -d '{"user_input": "test", "mode": "oracle"}'
```

## 🔐 Security Guidelines

### Environment Variables
- ✅ Use `.env` untuk local development
- ❌ **JANGAN** commit `.env` ke repository
- ❌ **JANGAN** expose sensitive keys di frontend

### API Keys
- Store di Supabase project settings
- Use service role key hanya di backend
- Never expose API keys di client-side code

### Database Security
- RLS (Row Level Security) enabled
- Use parameterized queries
- Validate all inputs

## 📊 Adding New Crypto APIs

### 1. API Research
```bash
# Test API endpoints
curl "https://api.example.com/endpoint"
# Check rate limits
# Review documentation
# Test response format
```

### 2. Integration Example
```typescript
// In backend/supabase/functions/message/index.ts
async function getCryptoData() {
    const response = await fetch('https://api.example.com/data', {
        headers: {
            'X-API-Key': Deno.env.get('API_KEY')
        }
    });
    
    if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
    }
    
    return await response.json();
}
```

### 3. Error Handling
```typescript
try {
    const data = await getCryptoData();
    // Process data
} catch (error) {
    console.error('API Error:', error);
    // Return fallback data
    return "Data temporarily unavailable. Please try again.";
}
```

## 🐛 Bug Reporting

### Before Reporting
1. Check existing issues
2. Reproduce the bug
3. Check console logs
4. Test with different browsers

### Issue Template
```markdown
**Bug Description**
A clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected Behavior**
What you expected to happen

**Actual Behavior**
What actually happened

**Screenshots**
If applicable, add screenshots

**Environment**
- Browser: [e.g. Chrome 91]
- OS: [e.g. macOS Big Sur]
- Node.js: [e.g. 16.0.0]
```

## 📚 Documentation

### Required Documentation
- **README.md**: Project overview, setup, usage
- **API Documentation**: New endpoints dan methods
- **Feature Documentation**: Complex features
- **Changelog**: Version changes

### Documentation Standards
- Use clear, concise language
- Include code examples
- Add screenshots untuk UI changes
- Update existing docs saat changing features

## 🚀 Deployment

### Pre-deployment Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Environment variables set
- [ ] Database migrations applied
- [ ] No console errors
- [ ] Performance acceptable (< 3s response time)

### Deployment Process
```bash
# Deploy edge functions
./scripts/deploy_backend.sh

# Test production
npm run health:check

# Check logs
npm run logs
```

## 📈 Performance Guidelines

### API Response Time
- Target: < 3 seconds per request
- Cache: Implement for external APIs
- Rate Limiting: Handle gracefully

### Frontend Performance
- Minimize JavaScript bundle size
- Use efficient DOM manipulation
- Implement proper error boundaries
- Test on various devices

### Database Performance
- Optimize queries
- Use proper indexing
- Monitor connection pools
- Implement connection pooling

## 🎨 UI/UX Guidelines

### Design Principles
- **Consistent**: Follow existing design system
- **Accessible**: WCAG 2.1 compliance
- **Responsive**: Mobile-first design
- **Intuitive**: Clear navigation and actions

### Code Style
- Use Tailwind CSS classes
- Maintain consistent spacing
- Follow component structure
- Implement proper hover/focus states

## 🔄 Code Review Process

### Pull Request Requirements
1. **Clear Title**: Descriptive dan action-oriented
2. **Detailed Description**: What, why, how
3. **Screenshots**: For UI changes
4. **Testing**: Manual dan automated tests
5. **Documentation**: Updated if needed

### Review Checklist
- [ ] Code follows style guide
- [ ] Tests included dan passing
- [ ] Documentation updated
- [ ] No security vulnerabilities
- [ ] Performance acceptable
- [ ] Accessible design

### Reviewer Guidelines
- Be constructive dan respectful
- Focus on code quality
- Test the changes locally
- Provide clear feedback

## 📞 Getting Help

### Resources
- **[Discord Community](https://discord.gg/zkcodex)**: Real-time chat
- **[GitHub Issues](https://github.com/your-username/zkcodex-crypto-analysis/issues)**: Bug reports
- **[Documentation](docs/)**: Comprehensive guides
- **[Supabase Docs](https://supabase.com/docs)**: Backend guidance

### Communication
- **Issues**: Use GitHub Issues for bugs
- **Discussions**: Use GitHub Discussions for questions
- **Security**: Email security@zkcodex.com
- **General**: support@zkcodex.com

## 🎉 Recognition

### Contributors
- Your name will be added ke [CONTRIBUTORS.md](CONTRIBUTORS.md)
- GitHub contributor badge
- Mention in release notes

### Hall of Fame
- Significant bug fixes
- Major feature additions
- Documentation improvements
- Community support

---

**Thank you for contributing to ZKCodex! 🚀**

*Happy coding dan crypto analysis!*