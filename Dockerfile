FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. 기본 패키지 설치 (OpenCV 필요 X)
RUN apt-get update && apt-get install -y \
    git build-essential wget \
    && rm -rf /var/lib/apt/lists/*

# 2. 작업 디렉토리
WORKDIR /app

# 3. Darknet 소스 가져오기
RUN git clone https://github.com/pjreddie/darknet .

# 4. 혹시라도 OPENCV=1로 돼 있으면 0으로 강제 (없어도 에러 안 나게 || true)
RUN sed -i 's/OPENCV=1/OPENCV=0/' Makefile || true

# 5. Darknet 빌드 (OpenCV 없이)
RUN make

# 6. YOLOv3 weight 다운로드
RUN wget https://pjreddie.com/media/files/yolov3.weights -O yolov3.weights

# 7. 실행 스크립트 복사
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# 8. 컨테이너 실행 시 자동 실행할 명령
ENTRYPOINT ["/app/run.sh"]
