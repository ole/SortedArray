#!/bin/bash

# The build script used for continuous integration builds on Travis CI
# <https://travis-ci.org/>. Supports testing Swift Package Manager
# packages on macOS and Linux.

echo "Running on OS: ${TRAVIS_OS_NAME}"

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
    # macOS
    swift build --clean
    swift build
    swift test
elif [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
    # Linux
    echo "Using Docker image: ${DOCKER_IMAGE}"
    # Download the Docker container. This is not strictly necessary since
    # docker run would automatically download a missing container.
    docker pull ${DOCKER_IMAGE}
    # Share the current directory (where Travis checked out the repository)
    # with the Docker container.
    # Then, in the container, cd into that directory and run the tests.
    docker run --volume "$(pwd):/root/repo" ${DOCKER_IMAGE} /bin/bash -c "cd /root/repo; swift build --clean; swift build; swift test"
fi
