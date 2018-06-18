#!/bin/bash

# The build script used for continuous integration builds on Travis CI
# <https://travis-ci.org/>. Supports testing Swift Package Manager
# packages on macOS and Linux.

set -ue -o pipefail

echo "Running on OS: ${TRAVIS_OS_NAME}"

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
    # macOS
    # 1. Test using Swift Package Manager
    echo -e "\nBuilding with Swift Package Manager\n==================================="
    swift --version
    swift package clean
    swift build
    swift test --parallel --filter UnitTests
    swift test --filter PerformanceTests

    # 2. Test using xcodebuild
    echo -e "\nBuilding with xcodebuild\n========================"
    xcodebuild -version
    
    # Optional debug output:
    # xcodebuild -showsdks
    # instruments -s devices

    xcodebuild test -scheme SortedArray-macOS | xcpretty
    
    # Testing on iOS on Travis CI is a pain
    # Disable because it's not essential for this library
    # xcodebuild test -scheme SortedArray-iOS -destination "platform=iOS Simulator,name=iPhone 7,OS=latest" | xcpretty
    # xcodebuild test -scheme SortedArray-tvOS -destination "platform=tvOS Simulator,name=Apple TV,OS=latest" | xcpretty
    # # watchOS doesn't support unit tests.
    # xcodebuild build -scheme SortedArray-watchOS -destination="platform=watchOS Simulator,name=Apple Watch Series 2 - 38mm,OS=latest" | xcpretty

elif [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
    # Linux
    echo -e "\nUsing Docker image: ${DOCKER_IMAGE}\n============================="
    # Download the Docker container. This is not strictly necessary since
    # docker run would automatically download a missing container.
    docker pull "${DOCKER_IMAGE}"
    # Share the current directory (where Travis checked out the repository)
    # with the Docker container.
    # Then, in the container, cd into that directory and run the tests.
    docker run --volume "$(pwd):/package" "${DOCKER_IMAGE}" /bin/bash -c "cd /package; swift --version; swift package clean; swift build; swift test --parallel --filter UnitTests; swift test --filter PerformanceTests"
fi
