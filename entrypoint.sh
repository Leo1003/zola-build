#!/bin/sh
set -e
set -o pipefail

if [ -z "$SITE_DIR" ]; then
    SITE_DIR="."
fi

cd $SITE_DIR

echo "Start building..."
echo "Version: $(zola --version)"
echo "Arguments: $ZOLA_BUILD_ARGS"

zola build $ZOLA_BUILD_ARGS

