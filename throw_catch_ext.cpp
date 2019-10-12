#include "throw_catch.hpp"

void throwInExt(void) {
    printStackAddress(__PRETTY_FUNCTION__);
    throw std::runtime_error("Error");
}

void throwInCallee(void) {
    printStackAddress(__PRETTY_FUNCTION__);
    throwInMain();
}

void invokeFunc(std::function<void(void)>& func) {
    printStackAddress(__PRETTY_FUNCTION__);
    func();
}

/*
Local Variables:
mode: c++
coding: utf-8-dos
tab-width: nil
c-file-style: "stroustrup"
End:
*/
