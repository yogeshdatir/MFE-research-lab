#!/bin/bash

echo "🚀 Setting up Micro-Frontend Integration"
echo "========================================"

# Check if yarn is installed
if ! command -v yarn &> /dev/null; then
    echo "❌ Yarn is not installed. Please install yarn first."
    echo "   npm install -g yarn"
    exit 1
fi

echo "📦 Installing dependencies for Host application..."
cd host
yarn install
if [ $? -ne 0 ]; then
    echo "❌ Failed to install host dependencies"
    exit 1
fi
cd ..

echo "📦 Installing dependencies for React Remote..."
cd react-remote
yarn install
if [ $? -ne 0 ]; then
    echo "❌ Failed to install React remote dependencies"
    exit 1
fi
cd ..

echo "✅ Setup completed successfully!"
echo ""
echo "🚀 To start the applications:"
echo "   1. Start React Remote: cd react-remote && yarn start"
echo "   2. Start Host App: cd host && yarn start"
echo "   3. Visit the MFE Demo page in your PHP application"
echo ""
echo "📝 Applications will run on:"
echo "   - React Remote: http://localhost:3002"
echo "   - Host App: http://localhost:3001"
echo "   - PHP App: http://localhost:8000"
