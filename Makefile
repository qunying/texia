# clear all build in suffixes
.SUFFIX:

PROJECT=texia

all:
	gnatmake -P $(PROJECT)

clean:
	gnatclean -P $(PROJECT)
