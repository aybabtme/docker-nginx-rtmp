Run it like (from root of repo):

```
docker run -it -p 8080:8080 -p 1935:1935 -v $(pwd)/example/broadcast/nginx.conf:/etc/nginx/nginx.conf:ro --rm aybabtme/nginx-rtmp:latest
```

Then start sending a stream:

```
sudo ffmpeg -i /dev/video0 -framerate 1 -video_size 720x404 -vcodec libx264 -maxrate 768k -bufsize 8080k -vf "format=yuv420p" -g 60 -f flv rtmp://localhost/webcam/video0
```