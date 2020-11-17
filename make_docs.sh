#!/bin/bash

cd MessageService
jazzy \
  --module MessageService \
  --swift-build-tool spm \
  --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5
open docs/index.html
