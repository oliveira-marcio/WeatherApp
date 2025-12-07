#!/usr/bin/env sh

xcodebuild test \
-project WeatherApp.xcodeproj \
-scheme WeatherApp \
-destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.1'
