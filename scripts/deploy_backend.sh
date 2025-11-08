#!/bin/bash

# ZKCodex Backend Deployment Script
# For production deployment

echo "🚀 ZKCodex Backend Deployment"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ .env file not found!${NC}"
    echo "Please copy .env.example to .env and configure your environment variables"
    exit 1
fi

# Source environment variables
source .env

# Validate required environment variables
required_vars=("SUPABASE_URL" "SUPABASE_ANON_KEY" "SUPABASE_SERVICE_ROLE_KEY")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo -e "${RED}❌ Missing required environment variables:${NC}"
    printf '   - %s\n' "${missing_vars[@]}"
    echo "Please check your .env file"
    exit 1
fi

echo -e "${GREEN}✅ Environment variables validated${NC}"

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI not found!${NC}"
    echo "Please install it: npm install -g supabase"
    exit 1
fi

echo -e "${GREEN}✅ Supabase CLI found${NC}"

# Check if user is logged in
if ! supabase status &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Supabase${NC}"
    echo "Please run: supabase login"
    exit 1
fi

echo -e "${GREEN}✅ Supabase authentication verified${NC}"

# Deploy edge functions
echo -e "\n${BLUE}📡 Deploying Edge Functions...${NC}"

echo "Deploying /message function..."
if supabase functions deploy message --no-verify-jwt; then
    echo -e "${GREEN}✅ /message function deployed${NC}"
else
    echo -e "${RED}❌ Failed to deploy /message function${NC}"
    exit 1
fi

echo "Deploying /verify function..."
if supabase functions deploy verify --no-verify-jwt; then
    echo -e "${GREEN}✅ /verify function deployed${NC}"
else
    echo -e "${RED}❌ Failed to deploy /verify function${NC}"
    exit 1
fi

# Test deployment
echo -e "\n${BLUE}🧪 Testing Deployment...${NC}"

# Test message function
test_response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
    -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
    -H "Content-Type: application/json" \
    -d '{"user_input": "deployment test", "mode": "oracle"}')

if echo "$test_response" | grep -q '"data"'; then
    echo -e "${GREEN}✅ /message function: WORKING${NC}"
else
    echo -e "${RED}❌ /message function: FAILED${NC}"
    echo "Response: $test_response"
fi

# Test verify function
hash=$(echo "$test_response" | jq -r '.data.codex_hash')
verify_response=$(curl -s "$SUPABASE_URL/functions/v1/verify?hash=$hash")

if echo "$verify_response" | grep -q '"verified"'; then
    echo -e "${GREEN}✅ /verify function: WORKING${NC}"
else
    echo -e "${RED}❌ /verify function: FAILED${NC}"
    echo "Response: $verify_response"
fi

# Build frontend if exists
if [ -d "frontend" ] || [ -f "index.html" ]; then
    echo -e "\n${BLUE}🏗️  Building Frontend...${NC}"
    
    if command -v npm &> /dev/null; then
        if [ -f "package.json" ]; then
            npm run build
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Frontend built successfully${NC}"
            else
                echo -e "${YELLOW}⚠️  Frontend build failed, but continuing...${NC}"
            fi
        fi
    fi
fi

# Final summary
echo -e "\n${GREEN}🎉 Deployment Summary${NC}"
echo "=================================="
echo "🔗 Supabase URL: $SUPABASE_URL"
echo "📡 Message API: $SUPABASE_URL/functions/v1/message"
echo "🔍 Verify API: $SUPABASE_URL/functions/v1/verify"
echo "🗄️  Database: $SUPABASE_URL/rest/v1/codex_entries"

echo -e "\n${BLUE}Next Steps:${NC}"
echo "1. Update any client-side configurations with the Supabase URL"
echo "2. Test the full application flow"
echo "3. Monitor function logs in Supabase dashboard"
echo "4. Configure custom domains if needed"

echo -e "\n${GREEN}🚀 Deployment completed successfully!${NC}"