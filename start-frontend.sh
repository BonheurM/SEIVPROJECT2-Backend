#!/bin/bash

# Frontend Server Startup Script
# This script starts the Vue.js frontend development server

echo "Starting SEIVPROJECT2 Frontend Server..."
echo "======================================="

# Navigate to frontend directory
FRONTEND_DIR="/Applications/XAMPP/xamppfiles/htdocs/SEIVPROJECT2/SEIVPROJECT2-Frontend"

if [ ! -d "$FRONTEND_DIR" ]; then
    echo "Error: Frontend directory not found at $FRONTEND_DIR"
    exit 1
fi

cd "$FRONTEND_DIR"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Node modules not found. Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install dependencies"
        exit 1
    fi
fi

# Start the development server
echo ""
echo "Starting Vue.js development server..."
echo "Frontend will be available at: http://localhost:8081"
echo "Backend API is running at: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the server"
echo "======================================="

# Run the dev script
npm run dev