# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

#
# GNU Make based build file.  For details on GNU Make see:
# http://www.gnu.org/software/make/manual/make.html
#

#
# Project information
#
# These variables store project specific settings for the project name
# build flags, files to copy or install.  In the examples it is typically
# only the list of sources and project name that will actually change and
# the rest of the makefile is boilerplate for defining build rules.
#
PROJECT:=buckets
CXX_SOURCES:=$(PROJECT).cc $(PROJECT)_main.cc
NACL_CXX_SOURCES:=$(PROJECT).cc $(PROJECT)_nacl.cc

THIS_MAKEFILE:=$(abspath $(lastword $(MAKEFILE_LIST)))

# Compute tool paths
OSNAME:=$(shell python $(NACL_SDK_ROOT)/tools/getos.py)
X86_TC_PATH:=$(abspath $(NACL_SDK_ROOT)/toolchain/$(OSNAME)_x86_newlib)
ARM_TC_PATH:=$(abspath $(NACL_SDK_ROOT)/toolchain/$(OSNAME)_arm_newlib)
X86_CXX:=$(X86_TC_PATH)/bin/i686-nacl-g++
ARM_CXX:=$(ARM_TC_PATH)/bin/arm-nacl-g++

# Project Build flags
WARNINGS:=-Wno-long-long -Wall -Wswitch-enum -pedantic -Werror
CXXFLAGS:=-std=gnu++98 $(WARNINGS)
CXXFLAGS:=$(CXXFLAGS) -I.
LDFLAGS:=

NACL_CXXFLAGS:=$(CXXFLAGS) -pthread -I$(NACL_SDK_ROOT)/include
NACL_LDFLAGS:=$(LDFLAGS) -lppapi_cpp -lppapi

NACL_LDFLAGS_X86_32:=-L$(NACL_SDK_ROOT)/lib/newlib_x86_32/Debug
NACL_LDFLAGS_X86_64:=-L$(NACL_SDK_ROOT)/lib/newlib_x86_64/Debug
NACL_LDFLAGS_ARM:=-L$(NACL_SDK_ROOT)/lib/newlib_arm/Debug

# Disable DOS PATH warning when using Cygwin based tools Windows
CYGWIN ?= nodosfilewarning
export CYGWIN

# Declare the ALL target first, to make the 'all' target the default build
all: console nacl

clean: clean_console clean_nacl

clean_nacl:
	$(RM) $(x86_32_OBJS) $(x86_64_OBJS) $(ARM_OBJS)
	$(RM) $(PROJECT)_x86_32.nexe $(PROJECT)_x86_64.nexe $(PROJECT)_arm.nexe

clean_console:
	$(RM) $(OBJS) $(PROJECT)

console: $(PROJECT)

nacl: $(PROJECT)_x86_32.nexe $(PROJECT)_x86_64.nexe $(PROJECT)_arm.nexe

# Define 32 bit compile and link rules for main application
OBJS:=$(patsubst %.cc,%.o,$(CXX_SOURCES))
$(OBJS) : %.o : %.cc $(THIS_MAKEFILE)
	$(CXX) -o $@ -c $< -O0 -g $(CXXFLAGS)

$(PROJECT) : $(OBJS)
	$(CXX) -o $@ $^ -m32 -O0 -g $(CXXFLAGS) $(LDFLAGS)

# Define 32 bit compile and link rules for main application
x86_32_OBJS:=$(patsubst %.cc,%_32.o,$(NACL_CXX_SOURCES))
$(x86_32_OBJS) : %_32.o : %.cc $(THIS_MAKEFILE)
	$(X86_CXX) -o $@ -c $< -m32 -O0 -g $(NACL_CXXFLAGS)

$(PROJECT)_x86_32.nexe : $(x86_32_OBJS)
	$(X86_CXX) -o $@ $^ -m32 -O0 -g $(NACL_CXXFLAGS) $(NACL_LDFLAGS_X86_32) $(NACL_LDFLAGS)

# Define 64 bit compile and link rules for C++ sources
x86_64_OBJS:=$(patsubst %.cc,%_64.o,$(NACL_CXX_SOURCES))
$(x86_64_OBJS) : %_64.o : %.cc $(THIS_MAKEFILE)
	$(X86_CXX) -o $@ -c $< -m64 -O0 -g $(NACL_CXXFLAGS)

$(PROJECT)_x86_64.nexe : $(x86_64_OBJS)
	$(X86_CXX) -o $@ $^ -m64 -O0 -g $(NACL_CXXFLAGS) $(NACL_LDFLAGS_X86_64) $(NACL_LDFLAGS)

# Define ARM compile and link rules for C++ sources
ARM_OBJS:=$(patsubst %.cc,%_arm.o,$(NACL_CXX_SOURCES))
$(ARM_OBJS) : %_arm.o : %.cc $(THIS_MAKEFILE)
	$(ARM_CXX) -o $@ -c $< -O0 -g $(NACL_CXXFLAGS)

$(PROJECT)_arm.nexe : $(ARM_OBJS)
	$(ARM_CXX) -o $@ $^ -O0 -g $(NACL_CXXFLAGS) $(NACL_LDFLAGS_ARM) $(NACL_LDFLAGS)

# Define a phony rule so it always runs, to build nexe and start up server.
.PHONY: RUN 
RUN: all
	python -m SimpleHTTPServer

X86_CXX?=$(X86_TC_PATH)/$(OSNAME)_x86_newlib/bin/i686-nacl-g++ -c
ARM_CXX?=$(X86_TC_PATH)/$(OSNAME)_arm_newlib/bin/arm-nacl-g++ -c
CXX?=g++ -c

