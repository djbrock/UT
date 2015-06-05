 # Standard things

include ./build/push_stack.mk

include build/library_builder.mk

# Standard things

-include	$(DEPS_$(d))

include ./build/pop_stack.mk

