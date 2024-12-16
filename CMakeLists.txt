cmake_minimum_required(VERSION 3.16.3)
project(simCHAI3D)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_MACOSX_RPATH 1)

if(NOT COPPELIASIM_INCLUDE_DIR)
    if(DEFINED ENV{COPPELIASIM_ROOT_DIR})
        set(COPPELIASIM_INCLUDE_DIR $ENV{COPPELIASIM_ROOT_DIR}/programming/include)
    else()
        set(COPPELIASIM_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../include)
    endif()
endif()
list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules
    ${COPPELIASIM_INCLUDE_DIR}/cmake)
find_package(CoppeliaSim 4.5.1.7 REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(OpenGL REQUIRED)
if(APPLE)
    find_library(CORE_FOUNDATION CoreFoundation REQUIRED)
    find_library(CORE_AUDIO CoreAudio REQUIRED)
    find_library(AUDIO_TOOLBOX AudioToolbox REQUIRED)
endif()

include(ExternalProject)
set(CHAI3D_VER 3.3.0)
set(CHAI3D_URL https://chai3d.org/download/chai3d-${CHAI3D_VER}-CMake.zip)
set(CHAI3D_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/chai3d-${CHAI3D_VER}-prefix)
set(CHAI3D_SRC_DIR ${CHAI3D_PREFIX}/src/chai3d-${CHAI3D_VER})
set(CHAI3D_BUILD_DIR ${CHAI3D_PREFIX}/src/chai3d-${CHAI3D_VER}-build)
ExternalProject_Add(chai3d-${CHAI3D_VER}
    URL ${CHAI3D_URL}
    CMAKE_ARGS -DCMAKE_BUYILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${CHAI3D_PREFIX}/install
    PATCH_COMMAND ${CMAKE_COMMAND} -E rm -rf ${CHAI3D_SRC_DIR}/examples
    COMMAND sed -i.bak "/#define C_USE_OPENGL/d" ${CHAI3D_SRC_DIR}/src/system/CGlobals.h
    COMMAND sed -i.bak "/file *(GLOB_RECURSE source_glew/d" ${CHAI3D_SRC_DIR}/CMakeLists.txt
    INSTALL_COMMAND ""
)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/generated)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/external)
include_directories(${CHAI3D_SRC_DIR}/src)
link_directories(${CHAI3D_BUILD_DIR})

coppeliasim_add_plugin(simCHAI3D
    LEGACY
    SOURCES
    sourceCode/simCHAI3D.cpp
    ${COPPELIASIM_INCLUDE_DIR}/simLib/scriptFunctionData.cpp
    ${COPPELIASIM_INCLUDE_DIR}/simLib/scriptFunctionDataItem.cpp
)
add_dependencies(simCHAI3D chai3d-${CHAI3D_VER})
target_link_libraries(simCHAI3D PRIVATE OpenGL::GL OpenGL::GLU)
target_link_libraries(simCHAI3D PRIVATE Eigen3::Eigen)
target_link_libraries(simCHAI3D PRIVATE chai3d)
if(APPLE)
    target_link_libraries(simCHAI3D PRIVATE ${CORE_AUDIO})
    target_link_libraries(simCHAI3D PRIVATE ${AUDIO_TOOLBOX})
endif()
