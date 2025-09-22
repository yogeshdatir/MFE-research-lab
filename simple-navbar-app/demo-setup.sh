#!/bin/bash

# =============================================================================
# 🚀 MICRO-FRONTEND DEMO - COMPLETE SETUP SCRIPT
# =============================================================================
# This script will install all dependencies and start all servers needed
# for the PHP Smarty + Module Federation demo
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if port is available
is_port_available() {
    ! lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1
}

# Function to wait for port to be ready
wait_for_port() {
    local port=$1
    local service=$2
    local max_attempts=30
    local attempt=1
    
    print_status "Waiting for $service to start on port $port..."
    
    while [ $attempt -le $max_attempts ]; do
        if ! is_port_available $port; then
            print_success "$service is ready on port $port!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_error "$service failed to start on port $port after $((max_attempts * 2)) seconds"
    return 1
}

# Function to kill process on port
kill_port() {
    local port=$1
    local pid=$(lsof -ti:$port)
    if [ ! -z "$pid" ]; then
        print_warning "Killing process on port $port (PID: $pid)"
        kill -9 $pid 2>/dev/null || true
        sleep 2
    fi
}

print_header "🚀 MICRO-FRONTEND DEMO SETUP"
echo ""
echo "This script will:"
echo "  ✅ Check and install required tools (PHP, Composer, Node.js, Yarn)"
echo "  ✅ Install all project dependencies"
echo "  ✅ Start all servers (PHP, React Remote, Host App)"
echo "  ✅ Open the demo in your browser"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo ""

# =============================================================================
# STEP 1: CHECK AND INSTALL DEPENDENCIES
# =============================================================================

print_header "📋 CHECKING SYSTEM REQUIREMENTS"

# Check PHP
if command_exists php; then
    PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2)
    print_success "PHP is installed (version: $PHP_VERSION)"
else
    print_error "PHP is not installed!"
    echo ""
    echo "Please install PHP first:"
    echo "  macOS: brew install php"
    echo "  Ubuntu: sudo apt install php php-cli"
    echo "  Windows: Download from https://www.php.net/downloads"
    exit 1
fi

# Check Composer
if command_exists composer; then
    COMPOSER_VERSION=$(composer --version | cut -d' ' -f3)
    print_success "Composer is installed (version: $COMPOSER_VERSION)"
else
    print_warning "Composer not found. Installing Composer..."
    
    # Download and install Composer
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --quiet
    php -r "unlink('composer-setup.php');"
    
    # Make it globally available
    sudo mv composer.phar /usr/local/bin/composer 2>/dev/null || mv composer.phar composer
    
    if command_exists composer; then
        print_success "Composer installed successfully!"
    else
        print_error "Failed to install Composer. Please install manually from https://getcomposer.org/"
        exit 1
    fi
fi

# Check Node.js
if command_exists node; then
    NODE_VERSION=$(node -v)
    print_success "Node.js is installed (version: $NODE_VERSION)"
else
    print_error "Node.js is not installed!"
    echo ""
    echo "Please install Node.js first:"
    echo "  Visit: https://nodejs.org/"
    echo "  Or use a version manager like nvm"
    exit 1
fi

# Check/Install Yarn
if command_exists yarn; then
    YARN_VERSION=$(yarn -v)
    print_success "Yarn is installed (version: $YARN_VERSION)"
else
    print_warning "Yarn not found. Installing Yarn..."
    npm install -g yarn
    
    if command_exists yarn; then
        print_success "Yarn installed successfully!"
    else
        print_error "Failed to install Yarn. Please install manually: npm install -g yarn"
        exit 1
    fi
fi

echo ""

# =============================================================================
# STEP 2: SETUP PROJECT DEPENDENCIES
# =============================================================================

print_header "📦 INSTALLING PROJECT DEPENDENCIES"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

print_status "Current directory: $SCRIPT_DIR"

# Install Composer dependencies (if composer.json exists)
if [ -f "composer.json" ]; then
    print_status "Installing PHP dependencies with Composer..."
    composer install --no-dev --optimize-autoloader
    print_success "PHP dependencies installed!"
else
    print_status "No composer.json found, skipping PHP dependencies"
fi

# Install React Remote dependencies
print_status "Installing React Remote dependencies..."
cd mfe-integration/react-remote
yarn install
print_success "React Remote dependencies installed!"

# Install Host App dependencies
print_status "Installing Host App dependencies..."
cd ../host
yarn install
print_success "Host App dependencies installed!"

cd "$SCRIPT_DIR"
echo ""

# =============================================================================
# STEP 3: CHECK AND CLEAN PORTS
# =============================================================================

print_header "🔍 CHECKING PORTS"

# Check if ports are available
PORTS_TO_CHECK=(8000 3001 3002)
PORTS_IN_USE=()

for port in "${PORTS_TO_CHECK[@]}"; do
    if ! is_port_available $port; then
        PORTS_IN_USE+=($port)
        print_warning "Port $port is already in use"
    else
        print_success "Port $port is available"
    fi
done

# Ask user if they want to kill processes on busy ports
if [ ${#PORTS_IN_USE[@]} -gt 0 ]; then
    echo ""
    print_warning "The following ports are in use: ${PORTS_IN_USE[*]}"
    read -p "Do you want to stop processes on these ports? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for port in "${PORTS_IN_USE[@]}"; do
            kill_port $port
        done
        print_success "Ports cleared!"
    else
        print_warning "Continuing with ports in use. Some services may fail to start."
    fi
fi

echo ""

# =============================================================================
# STEP 4: START ALL SERVERS
# =============================================================================

print_header "🚀 STARTING ALL SERVERS"

# Create log directory
mkdir -p logs

print_status "Starting React Remote server (port 3002)..."
cd mfe-integration/react-remote
yarn start > ../../logs/react-remote.log 2>&1 &
REACT_PID=$!
cd "$SCRIPT_DIR"

# Wait for React Remote to start
if wait_for_port 3002 "React Remote"; then
    print_success "React Remote server started (PID: $REACT_PID)"
else
    print_error "Failed to start React Remote server"
    kill $REACT_PID 2>/dev/null || true
    exit 1
fi

print_status "Starting Host App server (port 3001)..."
cd mfe-integration/host
yarn start > ../../logs/host-app.log 2>&1 &
HOST_PID=$!
cd "$SCRIPT_DIR"

# Wait for Host App to start
if wait_for_port 3001 "Host App"; then
    print_success "Host App server started (PID: $HOST_PID)"
else
    print_error "Failed to start Host App server"
    kill $HOST_PID 2>/dev/null || true
    kill $REACT_PID 2>/dev/null || true
    exit 1
fi

print_status "Starting PHP server (port 8000)..."
php -S localhost:8000 > logs/php-server.log 2>&1 &
PHP_PID=$!

# Wait for PHP server to start
if wait_for_port 8000 "PHP Server"; then
    print_success "PHP server started (PID: $PHP_PID)"
else
    print_error "Failed to start PHP server"
    kill $PHP_PID 2>/dev/null || true
    kill $HOST_PID 2>/dev/null || true
    kill $REACT_PID 2>/dev/null || true
    exit 1
fi

echo ""

# =============================================================================
# STEP 5: CREATE STOP SCRIPT
# =============================================================================

print_status "Creating stop script..."
cat > stop-demo.sh << EOF
#!/bin/bash
echo "🛑 Stopping Micro-Frontend Demo servers..."

# Kill servers
kill $PHP_PID 2>/dev/null && echo "✅ PHP server stopped" || echo "⚠️  PHP server was not running"
kill $HOST_PID 2>/dev/null && echo "✅ Host App stopped" || echo "⚠️  Host App was not running"
kill $REACT_PID 2>/dev/null && echo "✅ React Remote stopped" || echo "⚠️  React Remote was not running"

# Clean up any remaining processes on ports
for port in 8000 3001 3002; do
    pid=\$(lsof -ti:\$port 2>/dev/null)
    if [ ! -z "\$pid" ]; then
        kill -9 \$pid 2>/dev/null
        echo "🧹 Cleaned up process on port \$port"
    fi
done

echo ""
echo "🎉 All servers stopped successfully!"
echo "Run ./demo-setup.sh to start again"
EOF

chmod +x stop-demo.sh
print_success "Stop script created: ./stop-demo.sh"

echo ""

# =============================================================================
# STEP 6: SUCCESS MESSAGE AND INSTRUCTIONS
# =============================================================================

print_header "🎉 DEMO IS READY!"

echo ""
echo -e "${GREEN}✅ All servers are running successfully!${NC}"
echo ""
echo -e "${CYAN}📱 Access the demo at:${NC}"
echo -e "   ${YELLOW}Main Demo:${NC} http://localhost:8000"
echo -e "   ${YELLOW}MFE Demo:${NC} http://localhost:8000?page=mfe-demo"
echo ""
echo -e "${CYAN}🔧 Individual servers:${NC}"
echo -e "   ${YELLOW}PHP App:${NC}      http://localhost:8000"
echo -e "   ${YELLOW}Host App:${NC}     http://localhost:3001"
echo -e "   ${YELLOW}React Remote:${NC} http://localhost:3002"
echo ""
echo -e "${CYAN}📋 Server Process IDs:${NC}"
echo -e "   PHP Server: $PHP_PID"
echo -e "   Host App: $HOST_PID"
echo -e "   React Remote: $REACT_PID"
echo ""
echo -e "${CYAN}📝 Log files:${NC}"
echo -e "   logs/php-server.log"
echo -e "   logs/host-app.log"
echo -e "   logs/react-remote.log"
echo ""
echo -e "${CYAN}🛑 To stop all servers:${NC}"
echo -e "   ./stop-demo.sh"
echo ""

# Try to open browser
if command_exists open; then
    print_status "Opening demo in browser..."
    sleep 3
    open "http://localhost:8000?page=mfe-demo"
elif command_exists xdg-open; then
    print_status "Opening demo in browser..."
    sleep 3
    xdg-open "http://localhost:8000?page=mfe-demo"
elif command_exists start; then
    print_status "Opening demo in browser..."
    sleep 3
    start "http://localhost:8000?page=mfe-demo"
else
    print_warning "Could not auto-open browser. Please visit: http://localhost:8000?page=mfe-demo"
fi

echo ""
print_success "🚀 Micro-Frontend Demo is now running!"
echo ""
echo "Press Ctrl+C to stop all servers, or run ./stop-demo.sh"
echo ""

# Keep script running and handle Ctrl+C
trap 'echo ""; echo "🛑 Stopping servers..."; kill $PHP_PID $HOST_PID $REACT_PID 2>/dev/null; echo "✅ All servers stopped!"; exit 0' INT

# Wait for all background processes
wait
