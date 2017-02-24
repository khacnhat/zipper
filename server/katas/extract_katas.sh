#!/bin/bash
set -e

# I want zipper to be decoupled from web for its testing so
# I'm unable to create new katas in the storer.
# So I
#  o) extract known katas from a live storer (extract_katas.sh)
#  o) create a new data-container (create_data_container.sh)
#  o) save them into a volume (using fill_data_container.sh) which I then
#     mount as storer's volume.
#
# DADD67B4EF is an empty kata
# F6986222F0 is a kata with one avatar and no traffic-lights
# 1D1B0BE42D is a kata with one avatar and one traffic-lights
# 697C14EDF4 is a kata with one avatar and three traffic-lights
# 7AF23949B7 is a kata with three avatar each with three traffic-lights

my_dir="$( cd "$( dirname "${0}" )" && pwd )"
cd ${my_dir}

CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
VOLUME_PATH=/usr/src/cyber-dojo/katas

docker run --rm \
  --volumes-from ${CONTAINER_NAME} \
  --volume $(pwd):/extract \
  cyberdojo/ruby \
  tar cvf /extract/extract.tar ${VOLUME_PATH}

tar -xvf extract.tar

rm -rf DA
mkdir DA
mv usr/src/cyber-dojo/katas/DA/DD67B4EF DA

rm -rf F6
mkdir F6
mv usr/src/cyber-dojo/katas/F6/986222F0 F6

rm -rf 1D
mkdir 1D
mv usr/src/cyber-dojo/katas/1D/1B0BE42D 1D

rm -rf 69
mkdir 69
mv usr/src/cyber-dojo/katas/69/7C14EDF4 69

rm -rf 7A
mkdir 7A
mv usr/src/cyber-dojo/katas/7A/F23949B7 7A

rm -rf usr
rm extract.tar
