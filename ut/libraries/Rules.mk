 # Standard things

sp              := $(sp).x
dirstack_$(sp)  := $(d)
d               := $(dir)


# Subdirectories, in any order

dir     := $(d)/maths
include         $(dir)/Rules.mk

# Standard things

d               := $(dirstack_$(sp))
sp              := $(basename $(sp))