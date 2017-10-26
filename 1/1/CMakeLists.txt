project(qt-cmake-project)
cmake_minimum_required(VERSION 3.0)
find_package(Qt5 COMPONENTS Core Widgets)

include_directories(${Qt5Core_INCLUDE_DIRS})
include_directories(${Qt5Widgets_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set (PROJECTNAME_ARCHITECTURE "x64")

set(SOURCES
    test1.c
    widgets.cpp)

set(HEADERS
    widgets.h)

add_executable(
    task1
    ${SOURCES}
    ${HEADERS})

add_definitions(-DQT_NO_KEYWORDS)

target_link_libraries(task1
    ${Qt5Core_LIBRARIES}
    ${Qt5Widgets_LIBRARIES})