#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Lampa macOS Build Test Script${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Function to check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit 1
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}🔵 $1${NC}"
}

# Check prerequisites
echo -e "${BLUE}Step 1: Checking prerequisites...${NC}"
echo ""

if ! command_exists node; then
    echo -e "${RED}❌ Node.js not found!${NC}"
    echo "Install Node.js from: https://nodejs.org/"
    exit 1
fi
echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"

if ! command_exists npm; then
    echo -e "${RED}❌ npm not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✅ npm: $(npm --version)${NC}"

echo ""

# Install web dependencies
echo -e "${BLUE}Step 2: Installing web build dependencies...${NC}"
echo ""

if [ ! -d "node_modules" ]; then
    print_info "Installing dependencies (this may take a while)..."
    npm install
    print_status $? "Dependencies installed"
else
    print_info "Dependencies already installed"
    echo -e "${YELLOW}To reinstall, run: rm -rf node_modules && npm install${NC}"
fi

echo ""

# List Gulp version
echo -e "${BLUE}Step 3: Checking build tools...${NC}"
echo ""

if command_exists gulp; then
    echo -e "${GREEN}✅ Gulp (global): $(gulp --version)${NC}"
fi

if [ -f "node_modules/.bin/gulp" ]; then
    echo -e "${GREEN}✅ Gulp (local): $(npx gulp --version)${NC}"
fi

echo ""

# Build web version
echo -e "${BLUE}Step 4: Building web version...${NC}"
echo ""

print_info "Running: npm run build"
echo ""

if npm run build; then
    print_status 0 "Web build completed"
else
    print_status 1 "Web build failed"
    exit 1
fi

echo ""

# Verify build output
echo -e "${BLUE}Step 5: Verifying build output...${NC}"
echo ""

if [ ! -d "build/web" ]; then
    print_status 1 "build/web directory not found"
    exit 1
fi
print_status 0 "build/web directory exists"

if [ ! -f "build/web/index.html" ]; then
    print_status 1 "index.html not found"
    exit 1
fi
print_status 0 "index.html exists"

if [ ! -f "build/web/app.js" ]; then
    print_status 1 "app.js not found"
    exit 1
fi
print_status 0 "app.js exists"

echo ""
echo -e "${BLUE}📁 Build output:${NC}"
ls -lh build/web/ | head -n 20

echo ""

# Check file sizes
echo -e "${BLUE}Step 6: Checking file sizes...${NC}"
echo ""

WEB_SIZE=$(du -sh build/web | cut -f1)
echo -e "${GREEN}Web build size: $WEB_SIZE${NC}"

if [ -f "build/web/app.js" ]; then
    APP_SIZE=$(du -h build/web/app.js | cut -f1)
    echo -e "${GREEN}app.js size: $APP_SIZE${NC}"
fi

echo ""

# Test Electron preparation (optional)
echo -e "${BLUE}Step 7: Testing Electron preparation...${NC}"
echo ""

read -p "Do you want to test Electron build? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Preparing Electron build..."
    
    # Create directories
    mkdir -p electron/app
    mkdir -p electron/assets
    
    # Copy files
    print_info "Copying files to electron/app..."
    cp -r build/web/* electron/app/
    print_status $? "Files copied"
    
    # Verify
    if [ -f "electron/app/index.html" ] && [ -f "electron/app/app.js" ]; then
        print_status 0 "Electron app files verified"
    else
        print_status 1 "Electron app files missing"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}Step 8: Installing Electron dependencies...${NC}"
    echo ""
    
    cd electron
    
    if [ ! -d "node_modules" ]; then
        print_info "Installing Electron dependencies..."
        npm install
        print_status $? "Electron dependencies installed"
    else
        print_info "Electron dependencies already installed"
    fi
    
    echo ""
    echo -e "${BLUE}Step 9: Testing Electron app...${NC}"
    echo ""
    
    echo -e "${YELLOW}You can now:${NC}"
    echo -e "  1. Test the app: ${GREEN}npm start${NC}"
    echo -e "  2. Build DMG:    ${GREEN}npm run build:universal${NC}"
    echo -e "  3. Build ARM64:  ${GREEN}npm run build:mac-arm64${NC}"
    echo -e "  4. Build x64:    ${GREEN}npm run build:mac-x64${NC}"
    echo ""
    
    read -p "Do you want to start Electron app now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Starting Electron app..."
        npm start
    fi
    
    cd ..
else
    print_info "Skipping Electron test"
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  🎉 All tests passed!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Test in browser: ${GREEN}open build/web/index.html${NC}"
echo -e "  2. Start dev server: ${GREEN}npm start${NC}"
echo -e "  3. Build Electron:   ${GREEN}cd electron && npm install && npm run build${NC}"
echo ""
echo -e "${BLUE}GitHub Actions:${NC}"
echo -e "  - Push to trigger CI test"
echo -e "  - Create tag v1.0.0 for full release"
echo ""
