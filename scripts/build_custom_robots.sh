#!/usr/bin/env bash

#IS NECESSARY HAVE THE DOCKER IMAGE: jderobot/robotics-academy:manager

#before execute this script, uses: chmod +x scripts/build_custom_robots.sh

#command to execute this script on project root: ./scripts/build_custom_robots.sh

set -euo pipefail

# Absolute path of project
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WS_DIR="$PROJECT_ROOT/ws"
SRC_DIR="$WS_DIR/src"

# Docker manager's image
IMAGE_NAME="jderobot/robotics-academy:manager"

# Path to host's packages
CUSTOM_ROBOTS_SRC="$PROJECT_ROOT/CustomRobots"
JDEROBOT_DRONES_SRC="$PROJECT_ROOT/jderobot_drones"

echo "Deleting old workspace"
sudo rm -rf "$WS_DIR/build" "$WS_DIR/install" "$WS_DIR/log"

echo "Creating workspace in: $SRC_DIR ..."
mkdir -p "$SRC_DIR"

# Copy packages to ws/src/
echo "Copying packages in workspace..."
cp -r "$CUSTOM_ROBOTS_SRC" "$SRC_DIR/"
cp -r "$JDEROBOT_DRONES_SRC" "$SRC_DIR/"


echo "Building packages custom_robots inside container..."
docker run --rm -it \
  -v "$WS_DIR":/home/ws \
  -w /home/ws \
  --entrypoint bash \
  "$IMAGE_NAME" -lc "
    set -e
    source /opt/ros/humble/setup.bash
    colcon build --packages-select custom_robots
  "

echo "Build finished with success."
