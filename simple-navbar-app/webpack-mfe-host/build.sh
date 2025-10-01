#!/bin/bash

# Webpack MFE Host Build Script

echo "🏗️  Building Webpack MFE Host..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    yarn install
fi

# Build for production
echo "🔨 Building production bundle..."
yarn build

# Copy built files to Smarty public directory
echo "📋 Copying built files to Smarty public directory..."
mkdir -p ../public/webpack-mfe-host/
cp -r dist/* ../public/webpack-mfe-host/

echo "✅ Webpack MFE Host build complete!"
echo "📁 Built files copied to: public/webpack-mfe-host/"
echo "🚀 Ready for Smarty integration!"
