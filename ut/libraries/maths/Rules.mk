# Standard things

include ./build/push_stack.mk

# Local variables

#C_FILES_$(d) := $(wildcard $(d)/*.c)
#OBJS_D_$(d) := $(C_FILES_$(d):.c=.o)

# Collect unit test files. These have the same name as the file containing the function that they test
UT_C_FILES_$(d) := $(wildcard $(d)/ut_*.c)
UT_OBJS_D_$(d) := $(UT_C_FILES_$(d):.c=.o)
UT_SO_FILES_$(d) := $(UT_C_FILES_$(d):.c=.so)
UT_SO_X_FILES_$(d) := $(foreach sofile,$(UT_SO_FILES_$(d)),$(BUILDROOT)/$(sofile))

#$(info UT_SO_X_FILES $(UT_SO_X_FILES_$(d)))

UT_LDLIB_FILES_$(d) := $(subst ut_,libut_,$(UT_SO_X_FILES_$(d)))

#$(info UT_LDLIB_FILES $(UT_LDLIB_FILES_$(d)))

TEST_OBJS_tmp_$(d) := $(foreach obj, $(UT_OBJS_D_$(d)), ../build_root/$(PLATFORM)/$(obj))

#$(info TEST_OBJS_tmp $(TEST_OBJS_tmp_$(d)))

TEST_OBJS_$(d) := $(subst ut_,,$(TEST_OBJS_tmp_$(d)))

#$(info TEST_OBJS $(TEST_OBJS_$(d)))

# UT_SO_X_FILES ../build_root/MACOSX/libraries/maths/ut_add.so
# UT_LDLIB_FILES ../build_root/MACOSX/libraries/maths/libut_add.so
# TEST_OBJS_tmp  ../build_root/MACOSX/libraries/maths/ut_add.o
# TEST_OBJS  ../build_root/MACOSX/libraries/maths/add.o

OBJS_$(d) := $(foreach obj, $(UT_OBJS_D_$(d)), $(BUILDROOT)/$(obj))

TGT_LDLIB := $(TGT_LDLIB) $(UT_LDLIB_FILES_$(d))

DEPS_$(d) := $(OBJS_$(d):%=%.d)

#$(info pre maths $(CLEAN) )

CLEAN := $(CLEAN) $(TEST_OBJS_tmp_$(d)) $(DEPS_$(d))

#$(info want to add $(TEST_OBJS_tmp_$(d)))
#$(info should have added $(TEST_OBS_tmp_$(d)) $(DEPS_$(d)) )
#$(info post maths $(CLEAN) )

# The OBJ_BUNDLE collects all of the .o files from the main source tree that contain functions to be tested
OBJ_BUNDLE := $(OBJ_BUNDLE) $(TEST_OBJS_$(d)) 

# Local rules
# used to have -shared but clang complained
$(OBJS_$(d)):   CF_TGT := $(UT_CF_TGT) -I../src/$(d) 

$(BUILDROOT)/$(d)/%.a:          $(d)/%.b
	$(COMP)

# Do we need the -lmaths if we are going to link all of the .o files? We might still need to explicitly add LDLIB_EXTRA to each .so as it needs to have the same name as in the template.
$(BUILDROOT)/$(d)/libut_add.so: LDLIB_EXTRA := -L./../build_root/$(PLATFORM)/$(d)/ -lmaths

# SOLIB_template creates a rule to create each .so file. LD_LIB_EXTRA is added to the command line, and libut_foo.so is built from the corresponding ut_foo.o
$(foreach solib,$(UT_LDLIB_FILES_$(d)),$(eval $(call SOLIB_template,$(solib),$(subst libut,ut,$(solib:.so=.o)))))

$(BUILDROOT)/$(d)/%.o:          $(d)/%.c
	$(COMP)
                
# Standard things

-include        $(DEPS_$(d))

include ./build/pop_stack.mk

