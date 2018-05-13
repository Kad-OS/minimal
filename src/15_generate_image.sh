#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ./common.sh

echo "*** GENERATE IMAGE BEGIN ***"

# Prepare the work area.
rm -f $SRC_DIR/KadOS.tgz
rm -rf $WORK_DIR/kados
mkdir -p $WORK_DIR/kados

if [ -d $ROOTFS ] ; then
  # Copy the rootfs.
  cp -r $ROOTFS/* \
    $WORK_DIR/kados
else
  echo "Cannot continue - rootfs is missing."
  exit 1
fi

if [ -d $OVERLAY_ROOTFS ] && \
   [ ! "`ls -A $OVERLAY_ROOTFS`" = "" ] ; then

  echo "Merging overlay software in image."

  # Copy the overlay content.
  # With '--remove-destination' all possibly existing soft links in
  # $WORK_DIR/kados will be overwritten correctly.
  cp -r --remove-destination $OVERLAY_ROOTFS/* \
    $WORK_DIR/kados
  cp -r --remove-destination $SRC_DIR/minimal_overlay/rootfs/* \
    $WORK_DIR/kados
else
  echo "MLL image will have no overlay software."
fi

cd $WORK_DIR/kados

# Generate the image file (ordinary 'tgz').
tar -zcf $SRC_DIR/KadOS.tgz *

cat << CEOF

  ##################################################################
  #                                                                #
  #  KadOS image 'KadOS.tgz' has been generated.  #
  #                                                                #
  #  You can import the KadOS image in Docker like this:             #
  #                                                                #
  #    docker import KadOS.tgz kados:latest       #
  #                                                                #
  #  Then you can run KadOS shell in Docker container like this:     #
  #                                                                #
  #    docker run -it kados /bin/sh                   #
  #                                                                #
  ##################################################################

CEOF

echo "*** GENERATE IMAGE END ***"
