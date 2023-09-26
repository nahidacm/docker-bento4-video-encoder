#!/bin/bash

# Check if there are no arguments provided
if [ "$#" -eq 0 ]; then
    echo "Please provide one or more video file paths as arguments."
    exit 1
fi

# Loop through the provided video file paths
for input_video_file in "$@"; do

    timestamp=$(date "+%S-%M-%H-%d-%m-%Y")
    filename=$(basename -- "$input_video_file")
    foldername="${filename%.*}"

    # Check if the input video is already fragmented using mp4info
    if ./bento4/bin/mp4info ./input/"$input_video_file" | grep -q "fragments:  yes"; then

        echo "Input video is already fragmented. Now encoding..."
        ./bento4/bin/mp4dash -v -d "./input/$input_video_file" -o ./output/"$foldername-$timestamp"

        if [ $? -eq 0 ]; then
            echo "Conversion complete for $input_video_file"
        else
            echo "Error: Failed to encode the file $input_video_file."
            exit 1
        fi
    else
        echo "Input video is not fragmented. Fragmenting..."
        fragmented_video="${input_video_file%.mp4}_fragmented.mp4"
        ./bento4/bin/mp4fragment ./input/"$input_video_file" ./input/"$fragmented_video"
 
        # Check if mp4fragment was successful
        if [ $? -eq 0 ]; then
            echo "Video successfully fragmented. Now encoding..."
            ./bento4/bin/mp4dash -v -d ./input/"$fragmented_video" -o ./output/"$foldername-$timestamp"
        else
            echo "Error: Failed to fragment the video."
            exit 1
        fi
    fi
done

chmod -R 777 ./output

echo "All conversions are complete."

# Keep the container running
# tail -f /dev/null
