#!/bin/csh
echo $SHELL
echo "Starting build script:"
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

#perl -w build/annotate_revision.pl || exit
setenv VER 01_01
echo "Starting build"

# If we need to force a specific compiler version i.e. gcc-4.1, set CC here
#setenv CC gcc-3.3
make -f Makefile_top |& tee makelog.txt
#echo "Preload setting " $LD_PRELOAD
#echo "Library path setting " $LD_LIBRARY_PATH
echo "Build finished"

echo
echo -n "Count of warnings : "
echo `grep -c "warning:" makelog.txt`
echo -n "Count of errors : "
echo `grep -c "error:" makelog.txt`
echo
