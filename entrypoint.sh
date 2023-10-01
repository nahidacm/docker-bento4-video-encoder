#!/bin/bash

processDASH() {
    # Resize the video in multiple resulation, and save into the input folder
    echo "Resizing video..."
    # 1000K
    ffmpeg -i ./input/"$1" -c:v libx264 -b:v 1000k -s 1280x720 -c:a aac -b:a 128k -f mp4 ./input/"$2"_1000k.mp4
    ./bento4/bin/mp4fragment ./input/"$2"_1000k.mp4 ./input/"$2"_1000k_fragmented.mp4
    

    # 500K
    ffmpeg -i ./input/"$1" -c:v libx264 -b:v 500k -s 640x360 -c:a aac -b:a 128k -f mp4 ./input/"$2"_500k.mp4
    ./bento4/bin/mp4fragment ./input/"$2"_500k.mp4 ./input/"$2"_500k_fragmented.mp4

    # 250K
    ffmpeg -i ./input/"$1" -c:v libx264 -b:v 250k -s 320x180 -c:a aac -b:a 128k -f mp4 ./input/"$2"_250k.mp4
    ./bento4/bin/mp4fragment ./input/"$2"_250k.mp4 ./input/"$2"_250k_fragmented.mp4

    # Apply mp4dash
    ./bento4/bin/mp4dash -v -d ./input/"$2"_1000k_fragmented.mp4 ./input/"$2"_500k_fragmented.mp4 ./input/"$2"_250k_fragmented.mp4 -o ./output/"$2"
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

    processDASH $input_video_file $filename_without_extension

done

chmod -R 777 ./output
chmod -R 777 ./input

echo "All conversions are complete."

# Keep the container running
# tail -f /dev/null
