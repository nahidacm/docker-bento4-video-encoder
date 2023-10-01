#!/bin/bash

processDASH() {
    # Resize the video in multiple resulation, and save into the input folder
    echo "Resizing video..."
    # 1000K
    ffmpeg -i ./input/"$1" -c:v libx264 -b:v 1000k -s 1280x720 -c:a aac -b:a 128k -f mp4 ./input/"$2"_1000k.mp4
    if [ $? -eq 0 ]; then
        echo "Video successfully rezized. and saved to ./input/"$2"_1000k.mp4"
    else
        echo "Error: Failed to resize the video: ./input/"$1" =====> ./input/"$2"_1000k.mp4"
        exit 1
    fi

    # 500K
    ffmpeg -i ./input/"$1" -c:v libx264 -b:v 500k -s 640x360 -c:a aac -b:a 128k -f mp4 ./input/"$2"_500k.mp4
    if [ $? -eq 0 ]; then
        echo "Video successfully rezized. and saved to ./input/"$2"_500k.mp4"
    else
        echo "Error: Failed to resize the video."$2"_500k.mp4"
        exit 1
    fi

    # 250K
    ffmpeg -i ./input/"$1" -c:v libx264 -b:v 250k -s 320x180 -c:a aac -b:a 128k -f mp4 ./input/"$2"_250k.mp4
    if [ $? -eq 0 ]; then
        echo "Video successfully rezized. and saved to ./input/"$2"_500k.mp4"
    else
        echo "Error: Failed to resize the video."$2"_500k.mp4"
        exit 1
    fi

    # Apply mp4dash
    ./bento4/bin/mp4dash -v -d ./input/"$2"_1000k.mp4 ./input/"$2"_500k.mp4 ./input/"$2"_250k.mp4 -o ./output/"$2"
}


# Check if there are no arguments provided
if [ "$#" -eq 0 ]; then
    echo "Please provide one or more video file paths as arguments."
    exit 1
fi

# Loop through the provided video file paths
for input_video_file in "$@"; do

    filename=$(basename -- "$input_video_file")
    foldername="${filename%.*}"
    filename_without_extension="${filename%.*}"

    # Check if the input video is already fragmented using mp4info
    if ./bento4/bin/mp4info ./input/"$input_video_file" | grep -q "fragments:  yes"; then

        echo "Input video is already fragmented. Now encoding..."
        processDASH $input_video_file $filename_without_extension

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
            processDASH "$fragmented_video" "$filename_without_extension"
        else
            echo "Error: Failed to fragment the video."
            exit 1
        fi
    fi
done

chmod -R 777 ./output
chmod -R 777 ./input

echo "All conversions are complete."

# Keep the container running
# tail -f /dev/null
