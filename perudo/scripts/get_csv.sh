#!/bin/sh

if [ ! $# = 10 ]; then
    echo "Ca prend 10 arguments -_-"
    exit 1
fi

./run.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 | ./equal.py John | ./low_pass_filter.py ${10}
