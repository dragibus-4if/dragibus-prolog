#!/bin/sh

SWIPL=swipl
MIN_VERSION=6.2.6
VERSION=$($SWIPL --version | awk '{print $3}')

if [ "$VERSION" != "$MIN_VERSION" ]; then
    echo "SWI-Prolog version $MIN_VERSION expected, found $VERSION"
    exit 1
fi

if [ $# -lt 10 ]; then
    echo "Have to be called with 8 or 9 arguments :"
    echo "Usage : ./run.sh D1 E1 S1 I1 A1 D2 E2 S2 I2 A2 [N]"
    echo
    echo "D1 : proportion of iaDebile on player 1"
    echo "E1 : proportion of iaEleve on player 1"
    echo "S1 : proportion of iaStats on player 1"
    echo "I1 : proportion of iaIvre on player 1"
    echo "A1 : proportion of iaAutiste on player 1"
    echo "D2 : proportion of iaDebile on player 2"
    echo "E2 : proportion of iaEleve on player 2"
    echo "S2 : proportion of iaStats on player 2"
    echo "I2 : proportion of iaIvre on player 2"
    echo "A2 : proportion of iaAutiste on player 2"
    echo "N : number of games done"
    exit 1
fi
[ $# = 10 ] && N=1 || N=${11}
$SWIPL -q -s game -t "go($1, $2, $3, $4, $5, $6, $7, $8, $9, ${10}, $N)"
