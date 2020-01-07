#!/bin/sh

header_message="NuvlaBox MJPG Data Source service for video devices
\n\n
This component is only deployed on-demand, and takes care of streaming the raw MJPG data from a video peripheral via HTTP
"

usage="--device-path </dev/videoX> --input-type <input_uvc.so> --resolution <1280x720> --fps <15>"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
      --device-path)
      ARG_DEVICE="$2"
      shift # past argument
      shift # past value
      ;;
      --input-type)
      ARG_INPUT="$2"
      shift
      shift
      ;;
      --resolution)
      ARG_RESOLUTION="$2"
      shift
      shift
      ;;
      --fps)
      ARG_FPS="$2"
      shift
      shift
      ;;
      *)
      echo "ERR: Unknown ${1} ${2}. \n\t ${usage}"
      exit 128
      ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

device=${ARG_DEVICE}
device_params=""
if [[ ! -z $device ]]
then
  if [[ ! -e $device ]]
  then
    echo "ERR: cannot find ${device} in the system! Exiting..."
    exit 1
  else
    device_params=" -d ${device} "
  fi
fi

input_type=${ARG_INPUT:-"input_uvc.so"}
resolution=${ARG_RESOLUTION:-"1280x720"}
fps=${ARG_FPS:-15}

/usr/local/bin/mjpg_streamer -i "${input_type} -n -r ${resolution} ${device_params} -f ${fps}" \
                             -o "output_http.so -w /usr/local/share/mjpg-streamer/www -p 8082"

