#!/bin/bash
set -e

URL="$1"

if [ -z "$URL" ]; then
    echo "Usage: docker run <image_name> <image_url>"
    exit 1
fi

echo "Downloading image from: $URL"
wget -q -O input.jpg "$URL"

echo "Running YOLOv3 detection..."
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show -ext_output < /dev/null
