# Non-recursive Build System
## Overview
This document describes the build system used for a number of projects that I maintain. It is derived from examples given in a web article that discusses non-recursive methods of using make.

In this build system, make is invoked only once (at the top level). The top level make file causes a number of makefile fragments to be included from sub-directories. Each of these fragments can optionally:

* cause descent into further sub-directories
* cause a library to be build from source code files
* cause a binary to be created from source code and (optionally) libraries

The call to make is actually invoked from a build script that performs a check on the build platform to determine OS and other settings, and subsequently sets environment variables to pass this information to make.

The build is performed in a platform-specific directory, allowing multiple platforms to be built and tested at the same time. 

## Key technical parts
A stack is maintained within the makefile that is created by recursing the directory tree. This ensures that variable names do not collide.

We build unit tests as dynamic libraries because the unit test top level program can automatically scan the tree for them and add them to the set of tests to run at runtime. So we don’t need to alter the top level program every time we add a new test.