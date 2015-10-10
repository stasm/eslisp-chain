export PATH := node_modules/.bin:$(PATH)

all: index.js

%.js: %.esl
	@eslc -t eslisp-camelify -t eslisp-propertify < $< > $@

test: index.js test.js
	node test.js

test-readme: index.js readme.md
	txm readme.md

clean:
	rm -f *.js

.PHONY: all test clean
