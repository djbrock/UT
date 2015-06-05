# Standard things

include build/push_stack.mk

# Binary name
BIN_NAME_$(d) := example

#   List all algorithm directories (full path) that this binary requires
ALGS_$(d) := \
libraries/maths

# List any third-party libraries that need to be linked in as lib/libfoo.a
LIBS_$(d) := \

# List any system libraries that are needed
BINLIBS_$(d) := \
-lm

include build/binary_builder.mk

# Standard things

-include	$(DEPS_$(d))

include build/pop_stack.mk

