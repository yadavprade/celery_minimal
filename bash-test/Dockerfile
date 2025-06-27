# Use a minimal base image with bash
FROM alpine:latest

# # Install bash (Alpine uses ash by default)
# RUN apk add --no-cache sh

# Copy the script to the container
COPY spawntest.sh /app/spawntest.sh

# Make the script executable
RUN chmod +x /app/spawntest.sh

# Set the working directory
WORKDIR /app

# Run the script
CMD ["./spawntest.sh"]
