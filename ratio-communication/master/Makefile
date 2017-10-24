#############################################################################
#
# Makefile for DqR Ratio Communication Module
#
# Description:
# ------------
# Run: make && make install
# You can change the install directory by editing the prefix line
#
prefix := /usr/local

ARCH=armv6zk
ifeq "$(shell uname -m)" "armv7l"
ARCH=armv7-a
endif

# Detect the Raspberry Pi from cpuinfo
#Count the matches for BCM2708 or BCM2709 in cpuinfo
RPI=$(shell cat /proc/cpuinfo | grep Hardware | grep -c BCM2708)
ifneq "${RPI}" "1"
RPI=$(shell cat /proc/cpuinfo | grep Hardware | grep -c BCM2709)
endif

ifeq "$(RPI)" "1"
# The recommended compiler flags for the Raspberry Pi
CCFLAGS=-Ofast -mfpu=vfp -mfloat-abi=hard -march=$(ARCH) -mtune=arm1176jzf-s -std=c++11
endif

# define all programs
PROGRAMS = dqrMaster
SOURCES = dqrListener.cpp ${PROGRAMS:=.cpp}

all: ${PROGRAMS}

${PROGRAMS}: ${SOURCES}
#	g++ ${CCFLAGS} -Wall -I../ -lrf24-bcm -lrf24network -lrf24mesh -lmysqlcppconn $@.cpp -o $@
	g++ ${CCFLAGS} -Wall -I../ -lrf24-bcm -lrf24network -lrf24mesh -lmysqlcppconn $^ -o $@

clean:
	rm -rf $(PROGRAMS)

install: all
	test -d $(prefix) || mkdir $(prefix)
	test -d $(prefix)/bin || mkdir $(prefix)/bin
	for prog in $(PROGRAMS); do \
	  install -m 0755 $$prog $(prefix)/bin; \
	done
	rm -f $(PROGRAMS)

.PHONY: install
