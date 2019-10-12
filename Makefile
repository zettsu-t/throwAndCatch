GCC_VERSION:=$(shell export LC_ALL=C ; gcc -v 2>&1 | tail -1 | cut -d " " -f 3)
GCC_VERSION_NUMBER:=$(shell export LC_ALL=C ; g++ -v 2>&1 | tail -1 | sed -e "s/.* \\([0-9]\\)\\.\\([0-9]\\).*/\\1.\\2/")

MINGW_DIR=C:\MinGW
ISYSTEM_MINGW_INCLUDE_DIR=$(MINGW_DIR)\include
ISYSTEM_MINGW_CLANG_INCLUDE_DIRS = $(ISYSTEM_MINGW_INCLUDE_DIR) $(ISYSTEM_MINGW_INCLUDE_DIR)\c++\$(GCC_VERSION) $(ISYSTEM_MINGW_INCLUDE_DIR)\c++\$(GCC_VERSION)\x86_64-w64-mingw32 $(MINGW_DIR)\x86_64-w64-mingw32\include

INCLUDES_GXX=
INCLUDES_CLANGXX=
CLANG_TARGET=

ifeq ($(OS),Windows_NT)
ifneq (,$(findstring cygwin,$(shell gcc -dumpmachine)))
BUILD_ON_CYGWIN=yes
else
BUILD_ON_MINGW=yes
INCLUDES_GXX=$(addprefix -isystem ,$(ISYSTEM_MINGW_INCLUDE_DIR))
INCLUDES_CLANGXX=$(addprefix -isystem ,$(ISYSTEM_MINGW_CLANG_INCLUDE_DIRS))
CLANG_TARGET=-target x86_64-pc-windows-gnu
endif
endif

HEADERS=throw_catch.hpp
SOURCE_MAIN=throw_catch_main.cpp
SOURCE_EXT=throw_catch_ext.cpp
OBJ_MAIN_GCC=throw_catch_main_gcc.o
OBJ_EXT_GCC=throw_catch_ext_gcc.o
OBJ_MAIN_CLANG=throw_catch_main_clang.o
OBJ_MAIN_CLANG_ALT=throw_catch_main_clang_alt.o
OBJ_MAIN_CLANG_NOTHROW=throw_catch_main_clang_nothrow.o
OBJ_EXT_CLANG=throw_catch_ext_clang.o

OBJS_GCC=$(OBJ_MAIN_GCC) $(OBJ_EXT_GCC)
OBJS_CLANG=$(OBJ_MAIN_CLANG) $(OBJ_EXT_CLANG)
OBJS_CLANG_ALT=$(OBJ_MAIN_CLANG_ALT) $(OBJ_EXT_CLANG)
OBJS_CLANG_NOTHROW=$(OBJ_MAIN_CLANG_NOTHROW) $(OBJ_EXT_CLANG)
OBJS=$(OBJS_GCC) $(OBJS_CLANG) $(OBJS_CLANG_ALT) $(OBJS_CLANG_NOTHROW)

TARGET_GCC=throw_catch_gcc
TARGET_CLANG=throw_catch_clang
TARGET_CLANG_ALT=throw_catch_clang_alt
TARGET_CLANG_NOTHROW=throw_catch_clang_nothrow
TARGETS=$(TARGET_GCC) $(TARGET_CLANG) $(TARGET_CLANG_ALT) $(TARGET_CLANG_NOTHROW)

GXX=g++
CLANGXX=clang++
LD=g++

CPPFLAGS_ALT=-DCALL_FUNC_DIRECT
CPPFLAGS_NOTHROW=-DFUNCOBJ_NO_THROW
OPT=-O0 -g
##OPT=-O2

CPPFLAGS=-std=gnu++17 -Wall $(OPT)
GXX_CPPFLAGS=$(CPPFLAGS) $(INCLUDES_GXX)
CLANGXX_CPPFLAGS=$(CPPFLAGS) $(INCLUDES_CLANGXX) $(CLANG_TARGET)
LIBPATH=
LDFLAGS=
LIBS=

ECHO_START="\e[104m
ECHO_END=\e[0m"

.PHONY: all run clean

all: $(TARGETS)

$(TARGET_GCC): $(OBJS_GCC)
	$(LD) $(LIBPATH) -o $@ $^ $(LDFLAGS) $(LIBS)

$(TARGET_CLANG): $(OBJS_CLANG)
	$(LD) $(LIBPATH) -o $@ $^ $(LDFLAGS) $(LIBS)

$(TARGET_CLANG_ALT): $(OBJS_CLANG_ALT)
	$(LD) $(LIBPATH) -o $@ $^ $(LDFLAGS) $(LIBS)

$(TARGET_CLANG_NOTHROW): $(OBJS_CLANG_NOTHROW)
	$(LD) $(LIBPATH) -o $@ $^ $(LDFLAGS) $(LIBS)

run: $(TARGETS)
	@echo -e $(ECHO_START)$(TARGET_GCC)$(ECHO_END)
	-./$(TARGET_GCC)
	@echo -e $(ECHO_START)$(TARGET_CLANG_NOTHROW)$(ECHO_END)
	-./$(TARGET_CLANG_NOTHROW)
	@echo -e $(ECHO_START)$(TARGET_CLANG)$(ECHO_END)
	-./$(TARGET_CLANG)
	@echo -e $(ECHO_START)$(TARGET_CLANG_ALT)$(ECHO_END)
	-./$(TARGET_CLANG_ALT)

$(OBJ_MAIN_GCC): $(SOURCE_MAIN) $(HEADERS)
	$(GXX) $(GXX_CPPFLAGS) -o $@ -c $<

$(OBJ_EXT_GCC): $(SOURCE_EXT) $(HEADERS)
	$(GXX) $(GXX_CPPFLAGS) -o $@ -c $<

$(OBJ_MAIN_CLANG): $(SOURCE_MAIN) $(HEADERS)
	$(CLANGXX) $(CLANGXX_CPPFLAGS) -o $@ -c $<

$(OBJ_MAIN_CLANG_ALT): $(SOURCE_MAIN) $(HEADERS)
	$(CLANGXX) $(CLANGXX_CPPFLAGS) $(CPPFLAGS_ALT) -o $@ -c $<

$(OBJ_MAIN_CLANG_NOTHROW): $(SOURCE_MAIN) $(HEADERS)
	$(CLANGXX) $(CLANGXX_CPPFLAGS) $(CPPFLAGS_NOTHROW) -o $@ -c $<

$(OBJ_EXT_CLANG): $(SOURCE_EXT) $(HEADERS)
	$(CLANGXX) $(CLANGXX_CPPFLAGS) -o $@ -c $<

clean:
	rm -f $(TARGETS) $(OBJS)
