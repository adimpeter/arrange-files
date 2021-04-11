#!/bin/bash

# SORT SCRIPT V1.0
# DESCRIPTION: This little program sorts files into folders
# AUTHOR: ADIM PETER

echo "started"

SEARCH_DIR=~/Downloads

RED='\e[31mRed'
NC='\033[0m' # No Color

declare -a IMAGE_EXTENSION=("jpg" "jpeg" "png" "gif")
declare -a VIDEO_EXTENSION=("mp4" "avi" "ts" "mkv")
declare -a MUSIC_EXTENSION=("mp3" "m4a")

IMAGE_DIRECTORY=sorted_images/
MUSIC_DIRECTORY=sorted_songs/
VIDEO_DIRECTORY=sorted_videos/

# WHERE THE LOGS FOR THIS SCRIPT WILL BE STORED
PROGRAM_LOG_DIR=~/Desktop/SORT_PROGRAM
PROGRAM_LOG_FILE=status.log
PROGRAM_LOG_PATH=${PROGRAM_LOG_DIR}/${PROGRAM_LOG_FILE}

# THE SEARCH FILE WILL BE USED TO TRACK THE FILES IN SEARCH
# THE PROGRAM WILL LOOP THROUGH AND SORT USING THE FILE NAMES IN files.txt
SEARCH_FILE=${PROGRAM_LOG_DIR}/files.txt

IMAGE_DIRECTORY_PATH=${SEARCH_DIR}/${IMAGE_DIRECTORY}
MUSIC_DIRECTORY_PATH=${SEARCH_DIR}/${MUSIC_DIRECTORY}
VIDEO_DIRECTORY_PATH=${SEARCH_DIR}/${VIDEO_DIRECTORY}

# create 3 folders if they dont exist
# one for images
# one for videos
# one for music

mkdir -p ${IMAGE_DIRECTORY_PATH} ${MUSIC_DIRECTORY_PATH} ${VIDEO_DIRECTORY_PATH} ${PROGRAM_LOG_DIR}

# CREATE A LOG FILE
[ ! -f ${PROGRAM_LOG_PATH} ] && touch ${PROGRAM_LOG_PATH}

# CREATE SEARCH FILE
# EMPTY TOUCH FILE IF IT ALERADY EXIST
if [ ! -f ${SEARCH_FILE} ]; then
    touch ${SEARCH_FILE}
else
    echo '' > ${SEARCH_FILE}
fi

# LIST FILES IN SEARCH_DIR
ls ${SEARCH_DIR} >> ${SEARCH_FILE}


array_contains () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

move_file(){
   
    filename=$(basename -- "$1")
    extension="${1##*.}"

    if array_contains VIDEO_EXTENSION $extension ;then 
        echo -e "moving ${filename}" >> ${PROGRAM_LOG_PATH}
        mv -- "${SEARCH_DIR}/${filename}" $VIDEO_DIRECTORY_PATH
    fi

    if array_contains MUSIC_EXTENSION $extension ;then 
        echo -e "moving ${filename}" >> ${PROGRAM_LOG_PATH}
        mv -- "${SEARCH_DIR}/${filename}" $MUSIC_DIRECTORY_PATH
    fi

    if array_contains IMAGE_EXTENSION $extension ;then 
        echo -e "moving ${filename}" >> ${PROGRAM_LOG_PATH}
        mv -- "${SEARCH_DIR}/${filename}" $IMAGE_DIRECTORY_PATH
    fi
}



# READ SEARCH_FILE AND MOVE FILES TO THE RIGHT FOLDER
input=${SEARCH_FILE}
while IFS= read -r file_name
do

  move_file "${file_name}"

done < "$input"

echo "DONE"
echo "=============================================================" >> ${PROGRAM_LOG_PATH}
echo "=============================================================" >> ${PROGRAM_LOG_PATH}