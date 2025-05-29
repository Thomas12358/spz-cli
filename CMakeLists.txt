cmake_minimum_required(VERSION 3.10)

project(spz
  DESCRIPTION "A 3D Gaussians format"
  LANGUAGES C CXX
  VERSION 1.1.0)

# use of designated initializers requires at least '/std:c++20'
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)

# zlib is required to build the project
find_package(ZLIB REQUIRED)

set(spz_sources
  "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/load-spz.cc"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/splat-c-types.cc"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/splat-types.cc"
)

set(spz_headers
  "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/load-spz.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/splat-c-types.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/splat-types.h"
)

# create the library and configure it
add_library(spz ${spz_sources})

target_link_libraries(spz PRIVATE ZLIB::ZLIB)

target_include_directories(spz
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/cc>
  INTERFACE $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

set_target_properties(spz PROPERTIES
  PUBLIC_HEADER "${spz_headers}"
)

# CLI executable
add_executable(spzcli "${CMAKE_CURRENT_SOURCE_DIR}/src/cc/main.cc")
target_link_libraries(spzcli PRIVATE spz ZLIB::ZLIB)

# Optional: if main.cc includes any headers directly
target_include_directories(spzcli PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src/cc")

# Installation

## Install spzConfig.cmake spz::spz target can be found when calling find_package(spz)
include(CMakePackageConfigHelpers)
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/spzConfig.cmake.in"
  "${CMAKE_BINARY_DIR}/cmake/spzConfig.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/spz")
write_basic_package_version_file(
  "${CMAKE_BINARY_DIR}/cmake/spzConfigVersion.cmake"
  VERSION "${spz_VERSION}"
  COMPATIBILITY SameMajorVersion)
install(
  FILES
    "${CMAKE_BINARY_DIR}/cmake/spzConfig.cmake"
    "${CMAKE_BINARY_DIR}/cmake/spzConfigVersion.cmake"
  DESTINATION
    "${CMAKE_INSTALL_LIBDIR}/cmake/spz"
)

install(TARGETS spz
  EXPORT spzTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(EXPORT spzTargets
  NAMESPACE spz::
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/spz"
)

# Optional: install the CLI binary
install(TARGETS spzcli
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
