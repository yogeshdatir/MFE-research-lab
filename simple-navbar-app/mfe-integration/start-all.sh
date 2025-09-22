#!/bin/bash

echo "🚀 Starting all Micro-Frontend applications"
echo "==========================================="

# Function to check if port is in use
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Port $1 is already in use"
        return 1
    else
        return 0
    fi
}

# Check ports
echo "🔍 Checking ports..."
check_port 3001 || echo "   Host app port (3001) is busy"
check_port 3002 || echo "   React remote port (3002) is busy"

echo ""
echo "🚀 Starting React Remote on port 3002..."
cd react-remote
yarn start &
REACT_PID=$!

echo "⏳ Waiting for React Remote to start..."
sleep 5

echo "🚀 Starting Host Application on port 3001..."
cd ../host
yarn start &
HOST_PID=$!

echo ""
echo "✅ Applications started!"
echo "📝 Process IDs:"
echo "   React Remote PID: $REACT_PID"
echo "   Host App PID: $HOST_PID"
echo ""
echo "🌐 Access URLs:"
echo "   - React Remote: http://localhost:3002"
echo "   - Host App: http://localhost:3001"
echo "   - PHP App: http://localhost:8000"
echo ""
echo "⏹️  To stop all processes:"
echo "   kill $REACT_PID $HOST_PID"
echo ""
echo "Press Ctrl+C to stop all applications"

# Wait for user to stop
wait
