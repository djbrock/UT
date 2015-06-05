# Standard things

-include ./build/push_stack.mk


# Subdirectories, in random order

# Local variables

C_FILES_$(d) := $(wildcard $(d)/*.c)
OBJS_D_$(d) := $(C_FILES_$(d):.c=.o)

UT_C_FILES_$(d) := $(wildcard $(d)/ut_*.c)
UT_OBJS_D_$(d) := $(UT_C_FILES_$(d):.c=.o)
UT_SO_FILES_$(d) := $(UT_C_FILES_$(d):.c=.so)
UT_SO_X_FILES_$(d) := $(foreach sofile,$(UT_SO_FILES_$(d)),$(BUILDROOT)/$(sofile))
#UT_LDLIB_FILES_$(d) := $(subst ut_,libut_,$(BUILDROOT)/$(UT_SO_FILES_$(d)))
UT_LDLIB_FILES_$(d) := $(subst ut_,libut_,$(UT_SO_X_FILES_$(d)))

TEST_OBJS_tmp_$(d) := $(foreach obj, $(UT_OBJS_D_$(d)), ../build_root/$(PLATFORM)/$(obj))
TEST_OBJS_$(d) := $(subst ut_,,$(TEST_OBJS_tmp_$(d)))

OBJS_$(d) := $(foreach obj, $(OBJS_D_$(d)), $(BUILDROOT)/$(obj))

TGT_LDLIB  := $(TGT_LDLIB) $(UT_LDLIB_FILES_$(d))

DEPS_$(d)       := $(OBJS_$(d):%=%.d)

CLEAN           := $(CLEAN) $(OBJS_$(d)) $(DEPS_$(d)) $(TGT_BIN) $(TGT_LDLIB)

OBJ_BUNDLE := $(OBJ_BUNDLE) $(TEST_OBJS_$(d)) 

# Local rules
# used to have -shared but clang complained
$(OBJS_$(d)):   CF_TGT := -I../src/$(d) -fPIC

$(BUILDROOT)/$(d)/%.a:          $(d)/%.b
	$(COMP)

#$(foreach solib,$(UT_LDLIB_FILES_$(d)),$(eval $(call SOLIB_template,$(solib),$(subst lib,,$($(solib):.so=.o)))))
#$(foreach solib,$(UT_LDLIB_FILES_$(d)),$(eval $(call SOLIB_template,$(solib),$($(solib):.so=.o))))

#This was ok for linux
#$(BUILDROOT)/$(d)/libut_add.so: LDLIB_EXTRA := -Wl,-Bstatic -L./../build_root/$(PLATFORM)/$(d)/ -lmaths -Wl,-Bdynamic
$(BUILDROOT)/$(d)/libut_add.so: LDLIB_EXTRA := -L./../build_root/$(PLATFORM)/$(d)/ -lmaths
$(foreach solib,$(UT_LDLIB_FILES_$(d)),$(eval $(call SOLIB_template,$(solib),$(subst libut,ut,$(solib:.so=.o)))))

#$(foreach solib,$(UT_LDLIB_FILES_$(d)),$(eval $(call SOLIB_template,$(solib),guff)))

$(BUILDROOT)/$(d)/%.o:          $(d)/%.c
	$(COMP)
                
# Standard things

-include        $(DEPS_$(d))

-include ./build/pop_stack.mk

