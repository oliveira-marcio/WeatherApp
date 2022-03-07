#!/usr/bin/env sh

xcodebuild test \
-project WeatherApp.xcodeproj \
-scheme Mock \
-destination 'platform=iOS Simulator,name=iPhone 13,OS=15.2'

