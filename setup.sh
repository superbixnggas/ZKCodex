#!/bin/bash

# ZKCodex Quick Setup Script
# Automates development environment setup

set -e

echo "🚀 ZKCodex Development Setup"
echo "============================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    echo -e "\n${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        print_status "Node.js found: $NODE_VERSION"
        
        # Check if version is 16+
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$NODE_MAJOR" -lt 16 ]; then
            print_error "Node.js version 16+ required. Found: $NODE_VERSION"
            echo "Please update Node.js: https://nodejs.org"
            exit 1
        fi
    else
        print_error "Node.js not found"
        echo "Please install Node.js 16+: https://nodejs.org"
        exit 1
    fi
    
    # Check Git
    if command -v git &> /dev/null; then
        print_status "Git found: $(git --version)"
    else
        print_error "Git not found"
        echo "Please install Git: https://git-scm.com"
        exit 1
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        print_status "npm found: $NPM_VERSION"
    else
        print_error "npm not found"
        exit 1
    fi
    
    # Check Supabase CLI
    if command -v supabase &> /dev/null; then
        SUPABASE_VERSION=$(supabase --version)
        print_status "Supabase CLI found: $SUPABASE_VERSION"
    else
        print_warning "Supabase CLI not found"
        echo "Installing Supabase CLI..."
        npm install -g supabase
        print_status "Supabase CLI installed"
    fi
}

# Setup environment
setup_environment() {
    echo -e "\n${BLUE}⚙️  Setting up environment...${NC}"
    
    # Check if .env exists
    if [ ! -f .env ]; then
        print_info "Creating .env file from template..."
        cp .env.example .env
        print_status ".env file created"
        
        echo -e "\n${YELLOW}📝 IMPORTANT: Please edit .env file with your credentials${NC}"
        echo "   SUPABASE_URL and SUPABASE_ANON_KEY are already set"
        echo "   You need to get SUPABASE_SERVICE_ROLE_KEY from your Supabase dashboard"
    else
        print_warning ".env file already exists"
    fi
}

# Install dependencies
install_dependencies() {
    echo -e "\n${BLUE}📦 Installing dependencies...${NC}"
    
    if [ -f package.json ]; then
        npm install
        print_status "Dependencies installed"
    else
        print_error "package.json not found"
        exit 1
    fi
}

# Setup Supabase (optional)
setup_supabase() {
    echo -e "\n${BLUE}🗄️  Supabase setup (optional)...${NC}"
    
    read -p "Do you want to setup local Supabase for development? (y/n): " setup_local
    
    if [[ $setup_local == "y" || $setup_local == "Y" ]]; then
        print_info "Starting local Supabase..."
        supabase start
        print_status "Local Supabase started"
        
        # Get local keys
        echo -e "\n${YELLOW}Local Supabase keys:${NC}"
        supabase status
        
        echo -e "\n${GREEN}To connect to local Supabase:${NC}"
        echo "1. Copy local URL from supabase status"
        echo "2. Update .env file with local URL"
        echo "3. Run: supabase functions serve"
    else
        print_info "Skipping local Supabase setup"
        print_info "Using production Supabase at https://lrisuodzyseyqhukqvjw.supabase.co"
    fi
}

# Run tests
run_tests() {
    echo -e "\n${BLUE}🧪 Running initial tests...${NC}"
    
    if [ -f "scripts/test_backend.sh" ]; then
        print_info "Testing backend services..."
        bash scripts/test_backend.sh quick || {
            print_warning "Some tests failed, but that's okay for initial setup"
        }
        print_status "Backend tests completed"
    else
        print_warning "Backend test script not found"
    fi
    
    if [ -f "scripts/test_website.sh" ]; then
        print_info "Testing frontend..."
        bash scripts/test_website.sh || {
            print_warning "Frontend test failed, but that's okay"
        }
        print_status "Frontend tests completed"
    else
        print_warning "Frontend test script not found"
    fi
}

# Setup complete
show_next_steps() {
    echo -e "\n${GREEN}🎉 Setup Complete!${NC}"
    echo "=================================="
    
    echo -e "\n${BLUE}Next Steps:${NC}"
    echo "1. Edit .env file with your credentials"
    echo "2. Start development: npm run dev"
    echo "3. View logs: npm run logs"
    echo "4. Run tests: npm run test:quick"
    
    echo -e "\n${BLUE}Available Commands:${NC}"
    echo "  npm run dev              - Start development server"
    echo "  npm run test:quick       - Quick backend test"
    echo "  npm run deploy           - Deploy to production"
    echo "  npm run health:check     - Check system health"
    echo "  npm run status           - Show current status"
    
    echo -e "\n${BLUE}Documentation:${NC}"
    echo "  README.md               - Main documentation"
    echo "  docs/QUICK_START.md     - Quick start guide"
    echo "  docs/LOCAL_DEV_GUIDE.md - Development guide"
    echo "  CONTRIBUTING.md         - Contribution guidelines"
    
    echo -e "\n${BLUE}Production URLs:${NC}"
    echo "  Frontend: https://f30gia3n7psl.space.minimax.io"
    echo "  Backend:  https://lrisuodzyseyqhukqvjw.supabase.co"
    echo "  Message:  https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/message"
    echo "  Verify:   https://lrisuodzyseyqhukqvjw.supabase.co/functions/v1/verify"
}

# Health check
health_check() {
    echo -e "\n${BLUE}🏥 Health Check...${NC}"
    
    # Check environment
    if [ -f .env ]; then
        print_status ".env file exists"
        source .env
        
        # Check if required variables are set (using dummy values for check)
        if grep -q "SUPABASE_URL=" .env; then
            print_status "SUPABASE_URL configured"
        else
            print_warning "SUPABASE_URL not configured"
        fi
    else
        print_error ".env file missing"
    fi
    
    # Check if all required files exist
    if [ -f "frontend/index.html" ]; then
        print_status "Frontend files found"
    else
        print_warning "Frontend files missing"
    fi
    
    if [ -d "backend/supabase" ]; then
        print_status "Backend files found"
    else
        print_warning "Backend files missing"
    fi
    
    if [ -f "package.json" ]; then
        print_status "package.json found"
    else
        print_error "package.json missing"
    fi
}

# Main execution
main() {
    echo -e "${BLUE}Welcome to ZKCodex development setup!${NC}"
    echo "This script will help you setup your development environment."
    
    # Ask if user wants to proceed
    read -p "Continue with setup? (y/n): " proceed
    if [[ ! $proceed == "y" && ! $proceed == "Y" ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    
    check_prerequisites
    setup_environment
    install_dependencies
    health_check
    
    # Ask if user wants to setup local Supabase
    read -p "Setup local Supabase for development? (recommended for testing): " setup_local
    if [[ $setup_local == "y" || $setup_local == "Y" ]]; then
        setup_supabase
    fi
    
    run_tests
    show_next_steps
    
    echo -e "\n${GREEN}Happy coding! 🚀${NC}"
}

# Run main function
main "$@"