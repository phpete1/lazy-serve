#!/bin/bash

# Define file to store process IDs (PIDs)
PID_FILE="_serve.serve.pids"
LARAVEL_LOG="_serve.laravel.log"
VITE_LOG="_serve.vite.log"

# Defaults
DEFAULT_HOST="0.0.0.0"
DEFAULT_PORT="8000"

start() {
    # Capture optional host and port arguments
    HOST=${1:-}
    PORT=${2:-}

    echo "Starting Laravel server and Vite..."

    # Reset log files (overwrite if they exist)
    > $LARAVEL_LOG
    > $VITE_LOG

    # Run Laravel development server in the background, redirecting output to laravel.log
    if [ -n "$HOST" ] && [ -n "$PORT" ]; then
        php artisan serve --host=$HOST --port=$PORT > $LARAVEL_LOG 2>&1 &
    else
        php artisan serve > $LARAVEL_LOG 2>&1 &
    fi
    LARAVEL_PID=$! # Store the PID of the Laravel server

    # Run Vite (npm run dev) in the background, redirecting output to vite.log
    npm run dev > $VITE_LOG 2>&1 &
    VITE_PID=$! # Store the PID of the Vite server

    # Save both PIDs into a file
    echo $LARAVEL_PID > $PID_FILE
    echo $VITE_PID >> $PID_FILE

    echo "Laravel server started with PID $LARAVEL_PID (logs: $LARAVEL_LOG)"
    echo "Vite server started with PID $VITE_PID (logs: $VITE_LOG)"
}

stop() {
    if [ -f "$PID_FILE" ]; then
        echo "Stopping Laravel server and Vite..."

        # Read the PIDs from the file
        PIDS=$(cat $PID_FILE)

        # Kill both processes and their child processes
        for PID in $PIDS; do
            kill -- -$(ps -o pgid= $PID | grep -o '[0-9]*') # Kill the process group
            echo "Stopped process with PID $PID and its child processes"
        done

        # Remove the PID file
        rm $PID_FILE
    else
        echo "No servers are currently running."
    fi
}

# Parse the command-line argument (start/stop)
case "$1" in
    start)
        shift # Remove "start" from the argument list
        start "$@"
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: ./serve.sh {start|stop} [host] [port]"
        exit 1
        ;;
esac
