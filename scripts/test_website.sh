#!/bin/bash

# ZKCodex Website Testing Script
# Tests the deployed website at https://f30gia3n7psl.space.minimax.io

WEBSITE_URL="https://f30gia3n7psl.space.minimax.io"
SUPABASE_URL="https://lrisuodzyseyqhukqvjw.supabase.co"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxyaXN1b2R6eXNleXFodWtxdmp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1NjY2NjcsImV4cCI6MjA3ODE0MjY2N30.DRA4jM6TnkHv04g2WqXdnoM0XhwKD7OI6tl6hZlPviA"

echo "🧪 ZKCodex Website Testing"
echo "=========================="
echo "Website: $WEBSITE_URL"
echo "Backend: $SUPABASE_URL"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counter
total_tests=0
passed_tests=0

# Function to run test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    total_tests=$((total_tests + 1))
    echo -e "${BLUE}Test $total_tests: $test_name${NC}"
    
    if eval "$test_command"; then
        passed_tests=$((passed_tests + 1))
        echo -e "${GREEN}✅ PASSED${NC}"
    else
        echo -e "${RED}❌ FAILED${NC}"
    fi
    echo ""
}

# Test 1: Website Load
test_website_load() {
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$WEBSITE_URL")
    [ "$response" = "200" ]
}
run_test "Website loads successfully" "test_website_load"

# Test 2: HTML Content
test_html_content() {
    curl -s "$WEBSITE_URL" | grep -q "ZKCodex"
}
run_test "HTML contains ZKCodex title" "test_html_content"

# Test 3: CSS Styles
test_css_loading() {
    curl -s "$WEBSITE_URL" | grep -q "tailwindcss"
}
run_test "Tailwind CSS is loaded" "test_css_loading"

# Test 4: JavaScript Functions
test_javascript() {
    curl -s "$WEBSITE_URL" | grep -q "addMessage"
}
run_test "JavaScript functions present" "test_javascript"

# Test 5: Backend API Health
test_backend_health() {
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$SUPABASE_URL/rest/v1/codex_entries?select=count")
    [ "$response" = "200" ]
}
run_test "Backend database is accessible" "test_backend_health"

# Test 6: Message API
test_message_api() {
    local response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
        -H "Authorization: Bearer $ANON_KEY" \
        -H "Content-Type: application/json" \
        -d '{"user_input": "test website", "mode": "oracle"}')
    
    echo "$response" | grep -q '"data"'
}
run_test "Message API responds correctly" "test_message_api"

# Test 7: Verify API
test_verify_api() {
    # First get a hash
    local message_response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
        -H "Authorization: Bearer $ANON_KEY" \
        -H "Content-Type: application/json" \
        -d '{"user_input": "test verify", "mode": "analyzer"}')
    
    local hash=$(echo "$message_response" | jq -r '.data.codex_hash')
    
    # Then test verify with that hash
    local verify_response=$(curl -s "$SUPABASE_URL/functions/v1/verify?hash=$hash")
    echo "$verify_response" | grep -q '"data"'
}
run_test "Verify API works correctly" "test_verify_api"

# Test 8: AI Modes
test_ai_modes() {
    local modes=("oracle" "analyzer" "signal")
    local success=0
    
    for mode in "${modes[@]}"; do
        local response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
            -H "Authorization: Bearer $ANON_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"user_input\": \"test $mode\", \"mode\": \"$mode\"}")
        
        if echo "$response" | grep -q '"data"'; then
            success=$((success + 1))
        fi
    done
    
    [ $success -eq 3 ]
}
run_test "All AI modes working" "test_ai_modes"

# Test 9: CORS Headers
test_cors() {
    local response=$(curl -s -I -X OPTIONS "$SUPABASE_URL/functions/v1/message" \
        -H "Origin: $WEBSITE_URL")
    echo "$response" | grep -q "Access-Control-Allow-Origin"
}
run_test "CORS headers present" "test_cors"

# Test 10: Hash Generation
test_hash_generation() {
    local response=$(curl -s -X POST "$SUPABASE_URL/functions/v1/message" \
        -H "Authorization: Bearer $ANON_KEY" \
        -H "Content-Type: application/json" \
        -d '{"user_input": "hash test", "mode": "signal"}')
    
    local hash=$(echo "$response" | jq -r '.data.codex_hash')
    
    # Check hash format (should be 64 hex characters)
    if [[ $hash =~ ^[a-f0-9]{64}$ ]]; then
        echo "Hash format: OK"
        return 0
    else
        echo "Hash format: $hash"
        return 1
    fi
}
run_test "Hash generation format correct" "test_hash_generation"

# Summary
echo "=========================="
echo "🎯 Test Summary"
echo "=========================="
echo "Total Tests: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $((total_tests - passed_tests))"

if [ $passed_tests -eq $total_tests ]; then
    echo -e "${GREEN}🎉 All tests PASSED! Website is working correctly.${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests FAILED. Please check the issues above.${NC}"
    exit 1
fi