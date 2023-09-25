# Use the official Ubuntu image as the base image
FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    curl

# Set the working directory inside the container
WORKDIR /app

# Copy the Bento4 binaries from the local directory to the container
COPY ./bento4 /app/bento4

# Make the Bento4 binaries executable (replace 'bento4_executable1' and 'bento4_executable2' with the actual names)
RUN chmod +x /app/bento4/bin/mp4info && \
    chmod +x /app/bento4/bin/mp4dash && \
    chmod +x /app/bento4/bin/mp4hls && \
    chmod +x /app/bento4/bin/mp4fragment

# Create a directory to store the output MP4-DASH files
RUN mkdir -p /app/output

# Copy the entrypoint script into the container (create it as described below)
COPY entrypoint.sh /app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Define the entrypoint for the container
ENTRYPOINT ["/app/entrypoint.sh"]
