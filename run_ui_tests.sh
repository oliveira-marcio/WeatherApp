#!/usr/bin/env sh

xcodebuild test \
-project WeatherApp.xcodeproj \
-scheme Mock \
-destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.1'

