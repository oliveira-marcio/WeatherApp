#!/usr/bin/env sh

xcodebuild test \
-project WeatherApp.xcodeproj \
-scheme Mock \
-destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.2'

