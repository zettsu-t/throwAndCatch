#ifndef THROW_CATCH_HPP
#define THROW_CATCH_HPP

#include <cstdint>
#include <functional>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>

extern void throwInMain(void);
extern void throwInExt(void);
extern void throwInCallee(void);
extern void invokeFunc(std::function<void(void)>& func);

inline void printStackAddress(const std::string& s) {
    uint64_t rsp = 0;
    uint64_t rbp = 0;
    asm volatile (
        "mov %%rsp, %0 \n\t"
        "mov %%rbp, %1 \n\t"
        :"=r"(rsp),"=r"(rbp)::"memory");

    std::ostringstream os;
    os << s << ": " << "rsp=" << std::hex << rsp <<  ", rbp=" << rbp << "\n";
    std::cerr << os.str();
}

#endif // THROW_CATCH_HPP

/*
Local Variables:
mode: c++
coding: utf-8-dos
tab-width: nil
c-file-style: "stroustrup"
End:
*/
