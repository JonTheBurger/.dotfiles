#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y \
      build-essential \
      ccache \
      cppcheck \
      doxygen \
      g++ \
      gdb-multiarch \
      ninja-build \
      valgrind

    # Latest CMake
    if [ ! -f "/usr/share/keyrings/kitware-archive-keyring.gpg" ]; then
        wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
        echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list >/dev/null
        apt-get update
        rm /usr/share/keyrings/kitware-archive-keyring.gpg
        apt-get install kitware-archive-keyring
        apt-get install cmake
    fi

    # Latest Clang
    if ! grep -q "llvm-toolchain" "/etc/apt/sources.list" ; then
        wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
        add-apt-repository -y "deb http://apt.llvm.org/$(lsb_release -cs)/ llvm-toolchain-$(lsb_release -cs) main"
        apt-get update
        apt-get install -y \
          clang \
          clang-format \
          clang-tidy \
          clangd \
          lld \
          lldb

        # No generic versions of the following exist:
        CLANG_VERSION=$(clang --version | grep -o '[0-9]\+' | head -1)
        apt-get install -y \
          libfuzzer-${CLANG_VERSION}-dev
    fi
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

