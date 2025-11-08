#!/bin/bash

# ZKCodex Backend Test Script
# Usage: ./test_backend.sh [message|verify|all]

SUPABASE_URL="https://lrisuodzyseyqhukqvjw.supabase.co"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxyaXN1b2R6eXNleXFodWtxdmp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1NjY2NjcsImV4cCI6MjA3ODE0MjY2N30.DRA4jM6TnkHv04g2WqXdnoM0XhwKD7OI6tl6hZlPviA"

echo "🧪 ZKCodex Backend Testing"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test message API
test_message_api() {
    echo -e "\n${BLUE}📡 Testing /message API...${NC}"
    
    local response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
        -H "Authorization: Bearer $ANON_KEY" \
        -H "Content-Type: application/json" \
        -d '{"user_input": "test message from script", "mode": "oracle"}')
    
    if echo "$response" | grep -q '"data"'; then
        echo -e "${GREEN}✅ Message API: SUCCESS${NC}"
        echo "$response" | jq '.data.codex_hash' | head -1
        
        # Extract hash for verification test
        local hash=$(echo "$response" | jq -r '.data.codex_hash')
        echo "$hash" > /tmp/last_hash.txt
        
        return 0
    else
        echo -e "${RED}❌ Message API: FAILED${NC}"
        echo "$response"
        return 1
    fi
}

# Function to test verify API
test_verify_api() {
    echo -e "\n${BLUE}🔍 Testing /verify API...${NC}"
    
    if [ -f /tmp/last_hash.txt ]; then
        local hash=$(cat /tmp/last_hash.txt)
        echo "Testing with hash: $hash"
        
        local response=$(curl -s "$SUPABASE_URL/functions/v1/verify?hash=$hash")
        
        if echo "$response" | grep -q '"verified"'; then
            echo -e "${GREEN}✅ Verify API: SUCCESS${NC}"
            echo "$response" | jq '.data'
            return 0
        else
            echo -e "${RED}❌ Verify API: FAILED${NC}"
            echo "$response"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  No hash found, skipping verify test${NC}"
        return 1
    fi
}

# Function to test all modes
test_all_modes() {
    echo -e "\n${BLUE}🤖 Testing AI Modes...${NC}"
    
    local modes=("oracle" "analyzer" "signal")
    local success=0
    
    for mode in "${modes[@]}"; do
        echo -e "\n${YELLOW}Testing $mode mode:${NC}"
        
        local response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
            -H "Authorization: Bearer $ANON_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"user_input\": \"test $mode mode\", \"mode\": \"$mode\"}")
        
        if echo "$response" | grep -q '"data"'; then
            echo -e "${GREEN}✅ $mode mode: SUCCESS${NC}"
            local hash=$(echo "$response" | jq -r '.data.codex_hash')
            echo "   Hash: ${hash:0:16}..."
            success=$((success + 1))
        else
            echo -e "${RED}❌ $mode mode: FAILED${NC}"
        fi
    done
    
    echo -e "\n${BLUE}Summary: $success/3 modes working${NC}"
    return $((3 - success))
}

# Function to test database connection
test_database() {
    echo -e "\n${BLUE}🗄️  Testing Database Connection...${NC}"
    
    local response=$(curl -s "$SUPABASE_URL/rest/v1/codex_entries?select=count" \
        -H "Authorization: Bearer $ANON_KEY" \
        -H "apikey: $ANON_KEY")
    
    if echo "$response" | grep -q '"count"'; then
        echo -e "${GREEN}✅ Database: CONNECTED${NC}"
        local count=$(echo "$response" | jq '.[0].count')
        echo "   Total entries: $count"
        return 0
    else
        echo -e "${RED}❌ Database: FAILED${NC}"
        echo "$response"
        return 1
    fi
}

# Main execution
case "$1" in
    "message")
        test_message_api
        ;;
    "verify")
        test_verify_api
        ;;
    "all")
        test_all_modes
        test_database
        ;;
    "quick")
        test_message_api
        test_database
        ;;
    *)
        echo "Usage: $0 [message|verify|all|quick]"
        echo "  message  - Test /message API only"
        echo "  verify   - Test /verify API only"
        echo "  all      - Test all AI modes and database"
        echo "  quick    - Test message API and database"
        echo ""
        echo "Example: $0 all"
        exit 1
        ;;
esac

echo -e "\n${GREEN}🎉 Testing completed!${NC}"