cmake_minimum_required(VERSION 3.20)

project(simpleProgram LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(EXPORT_COMPILE_COMMANDS ON) # NOTE: not working? still set using justfile

add_executable(simpleProgram main.cpp)
