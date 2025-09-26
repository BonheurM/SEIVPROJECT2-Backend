#!/bin/bash

# Full Stack Application Startup Script
# This script starts both backend and frontend servers

echo "Starting SEIVPROJECT2 Full Stack Application"
echo "==========================================="

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Stopping all servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set trap for cleanup
trap cleanup EXIT INT TERM

# Start Backend
echo "Starting Backend Server..."
cd /Applications/XAMPP/xamppfiles/htdocs/SEIVPROJECT2/SEIVPROJECT2-Backend
npm start &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"

# Wait for backend to start
echo "Waiting for backend to initialize..."
sleep 5

# Start Frontend
echo ""
echo "Starting Frontend Server..."
cd /Applications/XAMPP/xamppfiles/htdocs/SEIVPROJECT2/SEIVPROJECT2-Frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing frontend dependencies..."
    npm install
fi

npm run dev &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"

# Display access information
echo ""
echo "==========================================="
echo "Application is starting up!"
echo ""
echo "Frontend: http://localhost:8081"
echo "Backend:  http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop both servers"
echo "==========================================="

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID