# Local rules and targets
C_FILES_$(d) := $(wildcard $(d)/*.c)
OBJS_D_$(d) := $(C_FILES_$(d):.c=.o)
OBJS_$(d) := $(foreach obj, $(OBJS_D_$(d)), $(BUILDROOT)/$(obj))
TGT_BIN  := $(TGT_BIN) $(BUILDROOT)/$(d)/$(BIN_NAME_$(d)) $(BUILDROOT)/$(d)/$(BIN_NAME_$(d))_$(VER)
DEPS_$(d)	:= $(OBJS_$(d):%=%.d)
CLEAN       := $(CLEAN) $(TGT_BIN) $(DEPS_$(d)) $(OBJS_$(d))

ALGS_INC_$(d) := $(foreach alg, $(ALGS_$(d)), -I./$(alg))
ALGS_LNK_$(d) := $(foreach alg, $(ALGS_$(d)), $(BUILDROOT)/$(alg)/lib$(notdir $(alg)).a)

$(OBJS_$(d)):	CF_TGT := $(ALGS_INC_$d)
$(BUILDROOT)/$(d)/$(BIN_NAME_$(d)):	LL_TGT := $(BINLIBS_$(d))

# This rule only checks that bin exists. It doesn't require it to be newer
$(BUILDROOT)/$(d)/$(BIN_NAME_$(d)): | ../bin

../bin :
	@mkdir ../bin

$(BUILDROOT)/$(d)/$(BIN_NAME_$(d)):	$(OBJS_$(d)) $(ALGS_LNK_$(d)) $(LIBS_$(d))
	$(LINK)
	@basename $@ | xargs echo "[Installing] "
	@basename $@ | xargs -I % cp $@ ../bin/%
	@basename $@ | xargs -I % cp $@ ../bin/%_$(VER)

$(BUILDROOT)/$(d)/%.o:		$(d)/%.c
		$(COMP)
