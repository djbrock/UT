THEDIR_$(d):= $(lastword $(subst /, ,$(d)))
LIBNAME_$(d) := lib$(THEDIR_$(d)).a

# Local variables
C_FILES_$(d) := $(wildcard $(d)/*.c)
OBJS_D_$(d) := $(C_FILES_$(d):.c=.o)

OBJS_$(d) := $(foreach obj, $(OBJS_D_$(d)), $(BUILDROOT)/$(obj))

DEPS_$(d)	:= $(OBJS_$(d):%=%.d)

CLEAN		:= $(CLEAN) $(OBJS_$(d)) $(DEPS_$(d)) \
		   $(BUILDROOT)/$(d)/$(LIBNAME_$(d))

TGT_LIB := $(TGT_LIB)  $(BUILDROOT)/$(d)/$(LIBNAME_$(d))

# Local rules

$(OBJS_$(d)):	CF_TGT := -I$(d)

$(BUILDROOT)/$(d)/$(LIBNAME_$(d)):	$(OBJS_$(d))
	$(MKLIB)

$(BUILDROOT)/$(d)/%.o:		$(d)/%.c
		$(COMP)
