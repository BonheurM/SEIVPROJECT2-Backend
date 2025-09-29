#!/bin/bash

echo "=== Testing Backend Endpoints ==="
echo ""

# Test the health endpoint
echo "1. Testing health endpoint:"
curl -s https://project2.eaglesoftwareteam.com/course-t2/health -w "\nHTTP Status: %{http_code}\n" || echo "Failed to connect"

echo -e "\n2. Testing base API endpoint:"
curl -s https://project2.eaglesoftwareteam.com/course-t2/ -w "\nHTTP Status: %{http_code}\n" || echo "Failed to connect"

echo -e "\n3. Testing courses endpoint:"
curl -s https://project2.eaglesoftwareteam.com/course-t2/api/courses -w "\nHTTP Status: %{http_code}\n" || echo "Failed to connect"

echo -e "\n4. Checking if backend is responding at all:"
curl -s https://project2.eaglesoftwareteam.com/course-t2 -w "\nHTTP Status: %{http_code}\n" -L || echo "Failed to connect"

echo -e "\n5. Testing with different paths:"
echo "   - Without trailing slash:"
curl -s https://project2.eaglesoftwareteam.com/course-t2 -w "\nHTTP Status: %{http_code}\n" || echo "Failed"

echo -e "\n   - With /api:"
curl -s https://project2.eaglesoftwareteam.com/course-t2/api -w "\nHTTP Status: %{http_code}\n" || echo "Failed"

echo -e "\n\nIf all endpoints return 503, the backend service is not running or Apache proxy is not configured."