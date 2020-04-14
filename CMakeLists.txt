# Disable in-source builds to prevent source tree corruption.
if(" ${CMAKE_SOURCE_DIR}" STREQUAL " ${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "FATAL: In-source builds are not allowed.
       You should create a separate directory for build files.")
endif()

# choose the architecture
set(DEPLOY_PLATFORM "unknown" CACHE STRING "choose the instruction set architecture")
set_property(CACHE DEPLOY_PLATFORM PROPERTY STRINGS unknown x86 arm64-v8a armeabi-v7a)
IF (${DEPLOY_PLATFORM} STREQUAL "unknown")
    message(FATAL_ERROR "choose the DEPLOY_PLATFORM")
    return() # This is to stop proceeding further and to stop opencv getting set to the default ANDROID_ABI
ENDIF()

# Set minimum cmake version + cmake settings
cmake_minimum_required (VERSION 3.9)

# Specify the project, and set the use of c++ and c
project(BCFTOOLS LANGUAGES CXX C)

message(STATUS "Configure BCFTOOLS")

# Set project name
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -Wl,--hash-style=both -fPIC -Wall -O3 -std=c11 -fsigned-char -D_FILE_OFFSET_BITS=64")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wl,--hash-style=both -fPIC -Wall -O3  -std=c++11 -fopenmp -fsigned-char -D_FILE_OFFSET_BITS=64")


include_directories(${PROJECT_SOURCE_DIR}/3rdparty)
include_directories(${PROJECT_SOURCE_DIR})


file(GLOB C_SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "*.c")
#file(GLOB_RECURSE CPP_SOURCES RELATIVE ${CMAKE_SOURCE_DIR} ".cpp")

list(REMOVE_ITEM C_SOURCES "peakfit.c")
list(REMOVE_ITEM C_SOURCES "polysomy.c")

#set (TABIX tabix.cpp)

message(STATUS "C_SOURCES=${C_SOURCES}")
#message(STATUS "CPP_SOURCES=${CPP_SOURCES}")

#add_executable(bcftools ${C_SOURCES})
add_library(bcftools SHARED ${C_SOURCES})

#add_library(hts SHARED IMPORTED)
set (libhts "${PROJECT_SOURCE_DIR}/3rdparty/${DEPLOY_PLATFORM}/libhts.so")

# link with dependencies
IF (${DEPLOY_PLATFORM} STREQUAL "x86")
    target_link_libraries(bcftools ${libhts} -ldl -lz -lm -lpthread)
ELSE()
    target_link_libraries(bcftools ${libhts} -ldl -lz -lm)
ENDIF()