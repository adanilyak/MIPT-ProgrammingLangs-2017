project(qt-cmake-project)
cmake_minimum_required(VERSION 3.0)
find_package(Qt5 COMPONENTS Core Widgets)

include_directories(${Qt5Core_INCLUDE_DIRS})
include_directories(${Qt5Widgets_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(PROJECTNAME_ARCHITECTURE "x64")

set(SOURCES
    widgets.cpp
    pywidgets.c)

set(MOC_HEADERS
    object.h)

set(HEADERS
    widgets.h)

qt5_wrap_cpp(MOC_SRC ${MOC_HEADERS})

add_executable(
    task3
    ${SOURCES}
    ${HEADERS}
    ${MOC_SRC})

add_definitions(-DQT_NO_KEYWORDS)

target_link_libraries(task3
    ${Qt5Core_LIBRARIES}
    ${Qt5Widgets_LIBRARIES})