#!/bin/bash

# Webpack MFE Host Development Script

echo "🚀 Starting Webpack MFE Host Development Server..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    yarn install
fi

# Start development server
echo "🔥 Starting development server on http://localhost:3001"
echo "📝 This is for testing the webpack host independently"
echo "🔗 For Smarty integration, use the build script instead"
echo ""

yarn start
