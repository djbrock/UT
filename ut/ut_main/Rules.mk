# Standard things

include build/push_stack.mk

# Subdirectories, in random order

# Local variables

C_FILES_$(d) := ut_main/ut_main.c
OBJS_D_$(d) := $(C_FILES_$(d):.c=.o)
OBJS_$(d) := $(foreach obj, $(OBJS_D_$(d)), $(BUILDROOT)/$(obj))
# The target here is deliberatly above this directory so that the algorithm directories will be searched for tests
TGT_BIN  := $(BUILDROOT)/ut_main_bin
DEPS_$(d)       := $(OBJS_$(d):%=%.d)

CLEAN := $(CLEAN) $(OBJS_$(d)) $(DEPS_$(d)) $(TGT_BIN) $(TGT_LDLIB)

# Local rules

$(OBJS_$(d)):   CF_TGT := -fPIC -shared

$(TGT_BIN):     LL_TGT := -ldl -lcunit -lz -lm
$(TGT_BIN):     LF_TGT := -rdynamic

$(TGT_BIN):     $(OBJS_$(d))
	$(LINK) $(OBJ_BUNDLE)

$(BUILDROOT)/$(d)/%.o:          $(d)/%.c
	$(COMP)
	
# Standard things

-include        $(DEPS_$(d))

include build/pop_stack.mk
























