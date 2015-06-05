#!/bin/csh

echo "Starting clean script:"
echo -n "  Detecting platform..."

setenv QUERY `uname -a`
echo "Query result: " $QUERY

setenv PLATFORM DONTKNOW

# Required to silence libBuildTrace messages from netbeans
setenv LD_PRELOAD

echo $QUERY | grep -q Linux && setenv PLATFORM LINUX
echo $QUERY | grep -q Darwin && setenv PLATFORM MACOSX

if ( $PLATFORM == LINUX ) then
    echo $QUERY | grep -q x86_64 && setenv PLATFORM LINUX64
endif

if ( $PLATFORM == DONTKNOW ) then
    echo "Unable to automatically determine platform."
    echo "Exiting. Code has not been built."
    exit
endif

echo "Starting clean"

make -f Makefile_top clean



