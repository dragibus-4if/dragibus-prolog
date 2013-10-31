#!/bin/sh

SWIPL=swipl
MIN_VERSION=6.2.6
VERSION=$($SWIPL --version | awk '{print $3}')

if [ "$VERSION" != "$MIN_VERSION" ]; then
    echo "SWI-Prolog version $MIN_VERSION expected, found $VERSION"
    exit 1
fi

[ $# = 0 ] && N=1 || N=$1
$SWIPL -q -s game -t "go($N)"
