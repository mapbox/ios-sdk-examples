endpoint_file=$SRCROOT/mapbox_endpoint
endpoint="$(cat $endpoint_file 2> /dev/null)"
INFO_PLIST="$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"

if [ "$endpoint" ]; then
    /usr/libexec/PlistBuddy -c "Delete :MGLMapboxAPIBaseURL" "$INFO_PLIST" 2> /dev/null
    /usr/libexec/PlistBuddy -c "Add :MGLMapboxAPIBaseURL string $endpoint" "$INFO_PLIST"
fi
