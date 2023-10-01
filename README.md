### Docker Bento4 video encoder
* mp4 to DASH

#### Building docker image
```bash
docker build -t bento4-video-encoder-image .
## Or
docker build -t bento4-video-encoder-image --target final . 
```

#### Usage instruction
Copy video files and folder into the `input` directory

Output files will be available on respected subfolder of `output` directory.

To have different input and output directory mount the volume in docker directory accordingly
 
#### Run the container to encode video
```bash
docker run -v ./output:/app/output -v ./input:/app/input bento4-video-encoder-image <input file1 path relative to input folder> <input file1 path relative to input folder>

# Example
docker run -v ./output:/app/output -v ./input:/app/input bento4-video-encoder-image sample/video1.mp4 sample/video2.mp4
# Or
docker run -v ./output:/app/output -v ./input:/app/input bento4-video-encoder-image sample/jumping-12mb.mp4
#Or
docker run -v /home/nahid/dev-dir/practice/laravel-video-streaming/storage/app/private/dash:/app/output -v ./input:/app/input bento4-video-encoder-image jumping-12mb.mp4
```

