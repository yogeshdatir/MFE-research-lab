#!/bin/bash

echo "🚀 Starting Micro-Frontend applications for Component Sharing Demo"
echo "=================================================================="

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
check_port 3002 || echo "   Task Manager MFE port (3002) is busy"
check_port 3003 || echo "   Dashboard MFE port (3003) is busy"

echo ""
echo "🚀 Starting Task Manager MFE on port 3002..."
cd react-remote
yarn start &
TASK_PID=$!

echo "⏳ Waiting for Task Manager to start..."
sleep 5

echo ""
echo "🚀 Starting Dashboard MFE on port 3003..."
cd ../dashboard-mfe
yarn start &
DASHBOARD_PID=$!

echo "⏳ Waiting for Dashboard to start..."
sleep 5

echo ""
echo "✅ MFE Applications started!"
echo "📝 Process IDs:"
echo "   Task Manager MFE PID: $TASK_PID"
echo "   Dashboard MFE PID: $DASHBOARD_PID"
echo ""
echo "🌐 Access URLs:"
echo "   - Task Manager MFE: http://localhost:3002"
echo "   - Dashboard MFE: http://localhost:3003"
echo "   - PHP Smarty App (with integrated host): http://localhost:8000"
echo ""
echo "🎯 Demo Instructions:"
echo "   1. Visit http://localhost:8000"
echo "   2. Click 'Task Manager' to see original TaskCard component"
echo "   3. Click 'Dashboard' to see shared TaskCard component"
echo ""
echo "⏹️  To stop all processes:"
echo "   kill $TASK_PID $DASHBOARD_PID"
echo ""
echo "Press Ctrl+C to stop all applications"

# Wait for user to stop
wait
