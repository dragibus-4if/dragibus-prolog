all:
	/bin/swipl --top_level=go --goal=true -O --stand_alone=true -o a.out -c game.pl

test:
	./a.out | tail -n 1
