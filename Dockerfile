FROM alpine:3.11.2 AS mjpg-streamer-builder

RUN apk update && apk add --no-cache linux-headers musl-dev gcc \
                           shadow make cmake wget jpeg-dev \
                           v4l-utils-dev imagemagick libgphoto2-dev \
                           sdl-dev protobuf-c-dev \
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

RUN apk update && apk add --no-cache v4l-utils-libs libgphoto2 tini curl \
               && rm -rf /var/cache/apk/*

COPY code/ /opt/nuvlabox/

HEALTHCHECK --interval=10s \
  CMD curl -f http://data-gateway/video/$(hostname) 2>&1 || (kill `pgrep tini` && exit 1)

WORKDIR /opt/nuvlabox/

ONBUILD RUN ./license.sh

ENTRYPOINT ["/sbin/tini", "--", "./run.sh"]
