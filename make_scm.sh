#!/bin/sh -x

LATEST=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/monkey0506/AGSModuleExporter/releases/latest)
TAG=${LATEST##*/}
EXPORTER=https://github.com/monkey0506/AGSModuleExporter/releases/download/$TAG/AGSModuleExporter.exe

wget -O /tmp/AGSModuleExporter.exe "${EXPORTER}"

mono /tmp/AGSModuleExporter.exe -script ./$1
