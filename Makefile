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

THIS_MAKEFILE:=$(abspath $(lastword $(MAKEFILE_LIST)))

# Project Build flags
WARNINGS:=-Wno-long-long -Wall -Wswitch-enum -pedantic -Werror
CXXFLAGS:=-std=gnu++98 $(WARNINGS)
CXXFLAGS:=$(CXXFLAGS) -I.
LDFLAGS:=

# Disable DOS PATH warning when using Cygwin based tools Windows
CYGWIN ?= nodosfilewarning
export CYGWIN

# Declare the ALL target first, to make the 'all' target the default build
all: $(PROJECT)

# Define 32 bit compile and link rules for main application
OBJS:=$(patsubst %.cc,%.o,$(CXX_SOURCES))
$(OBJS) : %.o : %.cc $(THIS_MAKEFILE)
	$(CXX) -o $@ -c $< -O0 -g $(CXXFLAGS)

$(PROJECT) : $(OBJS)
	$(CXX) -o $@ $^ -m32 -O0 -g $(CXXFLAGS) $(LDFLAGS)

CXX?=g++ -c

