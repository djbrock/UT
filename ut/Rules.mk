
# Standard stuff

.SUFFIXES:
.SUFFIXES:	.c .o

all:		targets

define SOLIB_template

$(1): $(2)
	$$(LDLIB) $$(LDLIB_EXTRA)

endef

# Subdirectories, in any order

dir := libraries
include     $(dir)/Rules.mk

dir	:= ut_main
include		$(dir)/Rules.mk

# General directory independent rules

%.o:		%.c
		$(COMP)

%:		%.o
		$(LINK)

%:		%.c
		$(COMPLINK)

# The variables TGT_*, CLEAN and CMD_INST* may be added to by the Makefile
# fragments in the various subdirectories.

.PHONY:		targets
targets:	$(TGT_LDLIB) $(TGT_BIN) $(TGT_SBIN) $(TGT_ETC) $(TGT_LIB) 

.PHONY:		clean
clean:
		rm -f $(CLEAN)

.PHONY:		install
install:	targets 
		$(INST) $(TGT_BIN) -m 755 -d $(DIR_BIN)
		$(CMD_INSTBIN)
		$(INST) $(TGT_SBIN) -m 750 -d $(DIR_SBIN)
		$(CMD_INSTSBIN)
ifeq ($(wildcard $(DIR_ETC)/*),)
		$(INST) $(TGT_ETC) -m 644 -d $(DIR_ETC)
		$(CMD_INSTETC)
else
		@echo Configuration directory $(DIR_ETC) already present -- skipping
endif
		$(INST) $(TGT_LIB) -m 750 -d $(DIR_LIB)
		$(CMD_INSTLIB)


# Prevent make from removing any build targets, including intermediate ones

.SECONDARY:	$(CLEAN)

