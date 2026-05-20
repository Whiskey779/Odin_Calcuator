#!/usr/bin/env bash

set -e

PROJECT_NAME="Odin_Calcuator"
SOURCE_DIR="."
BUILD_DIR="bin"

MODE="${2:-debug}"

case "$1" in
    build)
        mkdir -p "$BUILD_DIR"

        if [ "$MODE" = "release" ]; then
            echo "Building RELEASE..."
            odin build "$SOURCE_DIR" \
                -out:"$BUILD_DIR/$PROJECT_NAME" \
                -o:speed
        else
            echo "Building DEBUG..."
            odin build "$SOURCE_DIR" \
                -out:"$BUILD_DIR/Debug-$PROJECT_NAME" \
                -debug
        fi
        ;;

    run)
        mkdir -p "$BUILD_DIR"

        if [ "$MODE" = "release" ]; then
            echo "Running RELEASE..."
            odin run "$SOURCE_DIR" -o:speed
        else
            echo "Running DEBUG..."
            odin run "$SOURCE_DIR" -debug
        fi
        ;;

    clean)
        echo "Cleaning build directory..."
        rm -rf "$BUILD_DIR"
        ;;

    *)
        echo "Usage:"
        echo "  ./build.sh build [debug|release]"
        echo "  ./build.sh run [debug|release]"
        echo "  ./build.sh clean"
        exit 1
        ;;
esac