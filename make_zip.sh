#!/bin/sh -x

if [ ! -f ./$1.scm ]; then
    echo "Module not found. Cannot deploy zip archive."
else
    MODULE=$1
    shift
    zip $MODULE.zip ./$MODULE.scm "$@"
    echo "Zip archive created."
fi
