#!/usr/bin/env sh

xcodebuild test \
-project WeatherApp.xcodeproj \
-scheme WeatherApp \
-destination 'platform=iOS Simulator,name=iPhone 13,OS=15.2'
