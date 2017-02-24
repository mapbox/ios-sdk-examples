#!/bin/bash
set -e

MBGLVERSION='3.4.2'
#MBGLURL="https://github.com/mapbox/mapbox-gl-native/releases/download/ios-v$MBGLVERSION/mapbox-ios-sdk-$MBGLVERSION-symbols-dynamic.zip"
MBGLURL="http://mapbox.s3.amazonaws.com/mapbox-gl-native/ios/builds/mapbox-ios-sdk-$MBGLVERSION-symbols-dynamic.zip"
MBGLVANITYNAME="Mapbox iOS SDK v$MBGLVERSION"
TEMPZIPNAME="framework-$MBGLVERSION.zip"

echo "Downloading $MBGLVANITYNAME"
echo "URL: $MBGLURL"

if which curl > /dev/null; then
	curl -S -L -o $TEMPZIPNAME $MBGLURL
else
	echo "Error: curl not found"
	exit 1
fi

if [ -s $TEMPZIPNAME ]; then
	unzip -o $TEMPZIPNAME "dynamic/Mapbox.framework/*"
else
	echo "Error: failed to download $MBGLVANITYNAME from Github"
	exit 1
fi

if [ -d "dynamic/Mapbox.framework" ]; then
	if [ -d "Mapbox.framework" ]; then
		rm -rf "Mapbox.framework"
		echo "Removed existing Mapbox.framework"
	fi

	mv "dynamic/Mapbox.framework/" .
	rm $TEMPZIPNAME
	rm -rf "dynamic/"

	echo "Installed $MBGLVANITYNAME"
else
	echo "Failed to install $MBGLVANITYNAME"
	exit 1
fi
