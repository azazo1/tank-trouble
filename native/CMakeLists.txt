cmake_minimum_required(VERSION 3.20)
project(tank_trouble_native LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(GODOTCPP_BUILD_PROFILE "${CMAKE_CURRENT_SOURCE_DIR}/build-profile.json" CACHE PATH "" FORCE)
set(GODOTCPP_TARGET "template_debug" CACHE STRING "" FORCE)
set(GODOTCPP_DISABLE_EXCEPTIONS OFF CACHE BOOL "" FORCE)
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../vendor/godot-cpp-godot-4.4.1-stable" godot-cpp)

file(GLOB BOX2D_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../build/original-box2d/*.cpp")
add_library(original_box2d STATIC ${BOX2D_SOURCES} source/value.cpp)
target_include_directories(original_box2d PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/source")
target_compile_options(original_box2d PRIVATE -ffp-contract=off -O1)

add_library(tank_trouble_native SHARED physics/legacy_world.cpp register_types.cpp)
target_link_libraries(tank_trouble_native PRIVATE godot::cpp original_box2d)
target_compile_options(tank_trouble_native PRIVATE -ffp-contract=off)
set_target_properties(tank_trouble_native PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../game/native/bin"
  PREFIX "lib"
)
