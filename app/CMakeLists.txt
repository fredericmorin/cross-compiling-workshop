cmake_minimum_required(VERSION 3.0)

project(app LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/Modules)
find_package(PCAP REQUIRED)

add_executable(${PROJECT_NAME}
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
    )
target_link_libraries(${PROJECT_NAME}
    PUBLIC
        PCAP::PCAP
    )
target_compile_options(${PROJECT_NAME}
    PRIVATE
        -Wall -Wextra -Wpedantic -Werror
    )
