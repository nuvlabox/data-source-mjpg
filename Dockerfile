FROM alpine:3.11.2 AS mjpg-streamer-builder

RUN apk update && apk add --no-cache linux-headers=4.19.36-r0 musl-dev=1.1.24-r0 gcc=9.2.0-r3 \
                           shadow=4.7-r1 make=4.2.1-r2 cmake=3.15.5-r0 wget=1.20.3-r0 jpeg-dev=8-r6 \
                           v4l-utils-dev=1.18.0-r0 imagemagick=7.0.9.7-r0 libgphoto2-dev=2.5.23-r0 \
                           sdl-dev=1.2.15-r12 protobuf-c-dev=1.3.2-r3 \
               && rm -rf /var/cache/apk/*

WORKDIR /tmp

RUN wget https://github.com/jacksonliam/mjpg-streamer/archive/master.zip \
 && unzip master.zip && cd mjpg-streamer*/mjpg-streamer* && mkdir _build && cd _build \
 && cmake -DCMAKE_SHARED_LINKER_FLAGS="-Wl,--no-as-needed" .. \
 && make && make install

# ---

FROM alpine:3.11.2

ARG GIT_BRANCH
ARG GIT_COMMIT_ID
ARG GIT_BUILD_TIME
ARG GITHUB_RUN_NUMBER
ARG GITHUB_RUN_ID

LABEL git.branch=${GIT_BRANCH}
LABEL git.commit.id=${GIT_COMMIT_ID}
LABEL git.build.time=${GIT_BUILD_TIME}
LABEL git.run.number=${GITHUB_RUN_NUMBER}
LABEL git.run.id=${TRAVIS_BUILD_WEB_URL}

ENV LD_LIBRARY_PATH='/opt/vc/lib/:/usr/local/lib/mjpeg_streamer'

COPY --from=mjpg-streamer-builder /usr/local/lib/mjpg-streamer /usr/local/lib/mjpg-streamer
COPY --from=mjpg-streamer-builder /usr/local/bin/mjpg_streamer /usr/local/bin/mjpg_streamer
COPY --from=mjpg-streamer-builder /usr/local/share/mjpg-streamer/www /usr/local/share/mjpg-streamer/www

RUN apk update && apk add --no-cache v4l-utils-libs=1.18.0-r0 libgphoto2=2.5.23-r0 tini curl \
               && rm -rf /var/cache/apk/*

COPY code/ /opt/nuvlabox/

HEALTHCHECK --interval=10s \
  CMD curl -f http://data-gateway/video/$(hostname) 2>&1 || (kill `pgrep tini` && exit 1)

WORKDIR /opt/nuvlabox/

ONBUILD RUN ./license.sh

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["./run.sh"]