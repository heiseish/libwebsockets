#
# CMake Toolchain file for crosscompiling on Mediatek Linkit 7967
#
# This can be used like this (with Linkit sdk unpacked to /projects/linkit/sdk)
#
#  cd build/
#  cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/projects/linkit/cross-root \
#           -DCMAKE_TOOLCHAIN_FILE=../contrib/cross-linkit.cmake \
#           -DLWS_PLAT_FREERTOS=1 \
#           -DLWS_WITH_ZLIB=0 \
#           -DLWS_WITHOUT_EXTENSIONS=1 \
#           -DLWS_WITH_ZIP_FOPS=0 \
#           -DLWS_WITH_HTTP_STREAM_COMPRESSION=0 \
#           -DLWS_WITH_MBEDTLS=1 \
#           -DLWS_WITH_FILE_OPS=0
#

# if your sdk lives somewhere else, this is the only place that should need changing
set(CROSS_BASE /projects/linkit/sdk)
set(CROSS_PATH ${CROSS_BASE}/tools/gcc/gcc-arm-none-eabi)

#
# Target operating system name.
set(CMAKE_SYSTEM_NAME Generic)

# Name of C compiler.
set(CMAKE_C_COMPILER "${CROSS_PATH}/bin/arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "${CROSS_PATH}/bin/arm-none-eabi-g++")

#
# Different build system distros set release optimization level to different
# things according to their local policy, eg, Fedora is -O2 and Ubuntu is -O3
# here.  Actually the build system's local policy is completely unrelated to
# our desire for cross-build release optimization policy for code built to run
# on a completely different target than the build system itself.
#
# Since this goes last on the compiler commandline we have to override it to a
# sane value for cross-build here.  Notice some gcc versions enable broken
# optimizations with -O3.
#
if (CMAKE_BUILD_TYPE MATCHES RELEASE OR CMAKE_BUILD_TYPE MATCHES Release OR CMAKE_BUILD_TYPE MATCHES release)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nostartfiles -I${CROSS_BASE}/middleware/third_party/lwip/src/include/lwip -I${CROSS_BASE}/middleware/third_party/lwip/src/include -I${CROSS_BASE}/project/mt7687_hdk/apps/httpd/inc/ -I${CROSS_BASE}/kernel/service/inc/ -I${CROSS_BASE}/driver/chip/inc -I${CROSS_BASE}/driver/chip/mt7687/inc/ -I${CROSS_BASE}/driver/CMSIS/Device/MTK/mt7687/Include/ -I${CROSS_BASE}/driver/CMSIS/Include -I${CROSS_BASE}/middleware/third_party/lwip/ports/include/ -I${CROSS_BASE}/middleware/third_party/lwip/src/include/posix/ -I${CROSS_BASE}/kernel/rtos/FreeRTOS/Source/include/ -I${CROSS_BASE}/middleware/third_party/mbedtls/include/ -I${CROSS_BASE}/kernel/rtos/FreeRTOS/Source/portable/GCC/ARM_CM4F/ -I${CROSS_BASE}/middleware/third_party/sntp/inc/ -DLWS_AMAZON_RTOS=1")

# Where to look for the target environment. (More paths can be added here)
set(CMAKE_FIND_ROOT_PATH "${CROSS_PATH}")

# Adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search headers and libraries in the target environment only.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

