# clear all build in suffixes
.SUFFIX:

.phony: all test clean

PROJECT=texia
TEST_PROJECT=texia_tester
TEST_PRG=texia-tester

all:
	gnatmake -P $(PROJECT)

test:
	gnatmake -P $(TEST_PROJECT)
	./$(TEST_PRG)

clean:
	gnatclean -P $(PROJECT)
	gnatclean -P $(TEST_PROJECT)
