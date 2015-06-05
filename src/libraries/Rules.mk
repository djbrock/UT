include build/push_stack.mk

$(foreach thedir_$(d),$(shell find $(d) -depth 2 -name Rules.mk -exec dirname {} \; | xargs basename -a),$(eval dir:=$(d)/$(thedir_$(d))) $(eval include $(d)/$(thedir_$(d))/Rules.mk))

include build/pop_stack.mk

