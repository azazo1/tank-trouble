cmake_minimum_required(VERSION 3.20)
project(tank_trouble_native LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(GODOTCPP_BUILD_PROFILE "${CMAKE_CURRENT_SOURCE_DIR}/build-profile.json" CACHE PATH "" FORCE)
set(GODOTCPP_TARGET "template_debug" CACHE STRING "Godot 模板类型")
set(GODOTCPP_DISABLE_EXCEPTIONS OFF CACHE BOOL "" FORCE)

include(FetchContent)
if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()
# 固定 godot-4.4.1-stable 对应的提交和归档哈希, 源码缓存于构建目录.
FetchContent_Declare(godot_cpp
  URL "https://codeload.github.com/godotengine/godot-cpp/tar.gz/e4b7c25e721ce3435a029087e3917a30aa73f06b"
  URL_HASH "SHA256=7cd6104fb04013f88763555ed44974bc997f2f3c2829ba34569dba9268065102"
  TLS_VERIFY TRUE
)
message(STATUS "准备 godot-cpp 4.4.1: 首次下载并校验归档, 后续复用构建目录缓存")
FetchContent_MakeAvailable(godot_cpp)

file(GLOB BOX2D_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../build/original-box2d/*.cpp")
file(GLOB SPINE_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../build/original-spine/*.cpp")
file(GLOB P2_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../build/original-p2/*.cpp")
add_library(original_box2d STATIC ${BOX2D_SOURCES} ${SPINE_SOURCES} ${P2_SOURCES} source/value.cpp source/spine_builtins.cpp)
target_include_directories(original_box2d PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/source")
if(MSVC)
  target_compile_options(original_box2d PRIVATE /fp:precise /O1)
else()
  target_compile_options(original_box2d PRIVATE -ffp-contract=off -O1)
endif()

add_library(tank_trouble_native SHARED physics/legacy_world.cpp physics/original_p2.cpp animation/original_spine.cpp source/javascript_values.cpp register_types.cpp)
target_link_libraries(tank_trouble_native PRIVATE godot::cpp original_box2d)
if(MSVC)
  target_compile_options(tank_trouble_native PRIVATE /fp:precise)
else()
  target_compile_options(tank_trouble_native PRIVATE -ffp-contract=off)
endif()
set(native_output_dir "${CMAKE_CURRENT_SOURCE_DIR}/../game/native/bin")
set_target_properties(tank_trouble_native PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${native_output_dir}"
  RUNTIME_OUTPUT_DIRECTORY "${native_output_dir}"
  ARCHIVE_OUTPUT_DIRECTORY "${native_output_dir}"
  OUTPUT_NAME "tank_trouble_native.${GODOTCPP_TARGET}"
  PREFIX "lib"
  RUNTIME_OUTPUT_NAME "libtank_trouble_native.${GODOTCPP_TARGET}"
)
foreach(config DEBUG RELEASE RELWITHDEBINFO MINSIZEREL)
  set_target_properties(tank_trouble_native PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY_${config} "${native_output_dir}"
    RUNTIME_OUTPUT_DIRECTORY_${config} "${native_output_dir}"
    ARCHIVE_OUTPUT_DIRECTORY_${config} "${native_output_dir}"
  )
endforeach()
