# Run it like so, make sure cookies.txt is in your config mounted directiry
# docker run \
# -v "$CONFIG_DIR:/config" \
# -v "$OUTPUT_DIR:/output" \
# hbdownloader

FROM python:slim
RUN pip install humblebundle-downloader

CMD ["hbd", "--cookie-file", "/config/cookies.txt", "--library-path", "/output/hb-library", "--progress"]