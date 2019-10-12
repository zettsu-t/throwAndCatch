# throwAndCatch

## Summary

Throwing C++ exceptions crash in code which is compiled with clang++ 8 and running on Cygwin64.

## Preconditions

These software packages are required to reproduce the issue.

+ Windows 10 64-bit (Version 1903, OS build 18362.418)
+ Cygwin 64-bit installation 3.0.7
+ clang++ (version 8.0.1, Target: x86_64-unknown-windows-cygnus)
+ g++ 7.4.0 for Cygwin
+ GNU Make 4.2.1 for Cygwin
+ GNU gdb 8.1.1

## Steps to Reproduce

Check out this repository and build with GNU make.

```bash
## Execute on a Cygwin64 terminal
git clone https://github.com/zettsu-t/throwAndCatch.git
cd throwAndCatch
make
make run
```

## Actual and Expected results

Expected result:
A C++ caller function catches an exception which its callee function throws.

Actual result:
Throwing the exception crashes.

## Details

The caller function invokes a C++ free function which a std::function instance holds via a function.

```c++
void invokeFunc(std::function<void(void)>& func) {
    func();
}

void throwInLocal(void) {
    throw std::runtime_error("Error");
}

std::function<void(void)> funcObj = &throwInLocal;
invokeFunc(funcObj);
```

This is a backtrace on gdb.

```text
Thread 1 "throw_catch_clang" received signal ?, Unknown signal.
0x00007fface6ea839 in RaiseException () from /cygdrive/c/WINDOWS/System32/KERNELBASE.dll
(gdb) bt
#0  0x00007fface6ea839 in RaiseException () from /cygdrive/c/WINDOWS/System32/KERNELBASE.dll
#1  0x00000003de6bcbf1 in cyggcc_s-seh-1!_Unwind_RaiseException () from /usr/bin/cyggcc_s-seh-1.dll
#2  0x00000003c3599148 in cygstdc++-6!.cxa_throw () from /usr/bin/cygstdc++-6.dll
#3  0x0000000100401948 in (anonymous namespace)::throwInLocal () at throw_catch_main.cpp:11
#4  0x0000000100402c65 in std::_Function_handler<void (), void (*)()>::_M_invoke(std::_Any_data const&) (
    __functor=...) at /usr/lib/gcc/x86_64-pc-cygwin/7.4.0/include/c++/bits/std_function.h:316
#5  0x00000001004032aa in std::function<void ()>::operator()() const (this=0xffffcb58)
    at /usr/lib/gcc/x86_64-pc-cygwin/7.4.0/include/c++/bits/std_function.h:706
#6  0x00000000ffffc8a8 in ?? ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)
```

Invoking the std::function instance **after** the invocation prevents the crash.

## Additional information

Cygwin g++, MinGW g++ 8.2.0 and Windows native clang++ 8.0.1 (Target: x86_64-pc-windows-msvc) do not cause this issue.
