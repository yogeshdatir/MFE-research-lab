#!/bin/bash
echo "🛑 Stopping Micro-Frontend Demo servers..."

# Kill servers
kill 84261 2>/dev/null && echo "✅ PHP server stopped" || echo "⚠️  PHP server was not running"
kill 84194 2>/dev/null && echo "✅ React Remote stopped" || echo "⚠️  React Remote was not running"

# Clean up any remaining processes on ports
for port in 8000 3002; do
    pid=$(lsof -ti:$port 2>/dev/null)
    if [ ! -z "$pid" ]; then
        kill -9 $pid 2>/dev/null
        echo "🧹 Cleaned up process on port $port"
    fi
done

echo ""
echo "🎉 All servers stopped successfully!"
echo "Run ./demo-setup.sh to start again"
