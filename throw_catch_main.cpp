#include "throw_catch.hpp"

void throwInMain(void) {
    printStackAddress(__PRETTY_FUNCTION__);
    throw std::runtime_error("Error");
}

namespace {
    void throwInLocal(void) {
        printStackAddress(__PRETTY_FUNCTION__);
        throw std::runtime_error("Error");
    }
}

int main(int argc, char* argv[]) {
#ifdef __clang__
    std::cerr << __VERSION__ << "\n";
#else
    std::cerr << "g++ " << __VERSION__ << "\n";
#endif

    try {
        throwInLocal();
    } catch (std::runtime_error& e) {
        std::cerr << "Catch a std::runtime_error thrown by throwInLocal()\n\n";
    } catch (...) {
        std::cerr << "Catch an exception thrown by throwInLocal()\n\n";
    }

    try {
        throwInExt();
    } catch (std::runtime_error& e) {
        std::cerr << "Catch a std::runtime_error thrown by throwInExt()\n\n";
    } catch (...) {
        std::cerr << "Catch an exception thrown by throwInExt()\n\n";
    }

    try {
        throwInCallee();
    } catch (std::runtime_error& e) {
        std::cerr << "Catch a std::runtime_error thrown by throwInCallee()\n\n";
    } catch (...) {
        std::cerr << "Catch an exception thrown by throwInCallee()\n\n";
    }

    auto lambdaObj = [=]() {
        printStackAddress(__PRETTY_FUNCTION__);
        throw std::runtime_error("Error");
    };

    try {
        lambdaObj();
    } catch (std::runtime_error& e) {
        std::cerr << "Catch a std::runtime_error thrown by lambdaObj\n\n";
    } catch (...) {
        std::cerr << "Catch an exception thrown by lambdaObj\n\n";
    }

    std::function<void(void)> funcObj = &throwInLocal;

    try {
        // Call before func()
        invokeFunc(funcObj);
    } catch (std::runtime_error& e) {
        std::cerr << "Catch a std::runtime_error thrown by invokeFunc()\n\n";
    } catch (...) {
        std::cerr << "Catch an exception thrown by invokeFunc()\n\n";
    }

#ifdef CALL_FUNC_DIRECT
    try {
        // This invocation have invokeFunc(func) throw exceptions well
        funcObj();
    } catch (std::runtime_error& e) {
        std::cerr << "Catch a std::runtime_error thrown by func()\n\n";
    } catch (...) {
        std::cerr << "Catch an exception thrown by func()\n\n";
    }
#endif
    std::cerr << "End\n\n";
    return 0;
}

/*
Local Variables:
mode: c++
coding: utf-8-dos
tab-width: nil
c-file-style: "stroustrup"
End:
*/
