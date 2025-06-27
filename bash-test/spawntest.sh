#!/bin/sh

# Function to handle signals in the parent script
cleanup() {
    echo "Parent: Received signal $1, cleaning up..."
    if [[ -n $CHILD_PID ]]; then
        echo "Parent: Waiting for child process (PID: $CHILD_PID) to exit..."
        # commented out to prevent sending SIGTERM to the child process
        # kill -TERM $CHILD_PID 2>/dev/null
        wait $CHILD_PID 2>/dev/null
    fi
    echo "Parent: Exiting"
    exit 0
}

# Set up signal handlers for the parent

for sig in SIGTERM SIGINT; do
    trap "cleanup $sig" $sig
done

# mkdir -p /tmp

# Create the child process script
cat << 'EOF' > /tmp/child_process.sh
#!/bin/sh

# Function to handle signals in the child process
child_cleanup() {
    echo "Child: Received signal $1, exiting gracefully..."
    exit 0
}

# Set up signal handlers for the child
for sig in SIGTERM SIGINT; do
    trap "child_cleanup $sig" $sig
done

# Infinite loop that prints a message every second
count=0
while true; do
    count=$((count + 1))
    echo "Child: Running ($count)... (PID: $$)"
    sleep 1
done
EOF

# Make the child script executable
chmod +x /tmp/child_process.sh

# Spawn the child process
echo "Parent: Starting child process..."
/tmp/child_process.sh &
CHILD_PID=$!
echo "Parent: Child process started with PID: $CHILD_PID"

# Keep the parent script running
echo "Parent: Press Ctrl+C or send SIGTERM to stop..."
while true; do
    sleep 1
done