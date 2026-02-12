#!/bin/bash
# Start the entire threat detection pipeline

echo "=== Starting Docker (Kafka + Postgres) ==="
docker compose up -d

echo "Waiting for Kafka + Postgres to be ready..."
sleep 10

echo "=== Starting Ingestion Service (port 3000) ==="
npm run ingestion &
PID1=$!

echo "=== Starting Detection Service ==="
npm run detection &
PID2=$!

echo ""
echo "========================================="
echo "  Pipeline is running!"
echo "  Ingestion API: http://localhost:3000"
echo "  Kafka UI:      http://localhost:8080"
echo "  pgAdmin:       http://localhost:5050"
echo "  Use Postman to POST to /events"
echo "========================================="
echo ""
echo "Press Ctrl+C to stop everything"

trap "kill $PID1 $PID2 2>/dev/null; docker compose down; exit" SIGINT
wait
