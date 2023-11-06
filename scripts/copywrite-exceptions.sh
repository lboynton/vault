#!/bin/sh

# Used as a stopgap for copywrite bot in MPL-licensed subdirs, detects BUSL licensed
# headers and deletes them, then runs the copywrite bot to utilize local subdir config
# to inject correct headers.

find . -type f -name '*.go' | while read line; do
  if grep "SPDX-License-Identifier: BUSL-1.1" $line; then
    sed -i '' '/SPDX-License-Identifier: BUSL-1.1/d' $line
    sed -i '' '/Copyright (c) HashiCorp, Inc./d' $line
  fi
done

copywrite headers --plan
