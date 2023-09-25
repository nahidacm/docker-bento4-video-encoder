#### Building docker image
```bash
docker build -t bento4-video-encoder-image .
```

#### Run the container to encode video
```bash
docker run -v ./output:/app/output -v ./input:/app/input bento4-video-encoder-image <input file1 path relative to input folder> <input file1 path relative to input folder>

# Example
docker run -v ./output:/app/output -v ./input:/app/input bento4-video-encoder-image sample/video1.mp4 sample/video2.mp4
```

