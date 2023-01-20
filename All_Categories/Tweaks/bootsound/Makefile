TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BootSound

BootSound_FILES = Tweak.x
BootSound_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += bootsound.preference
include $(THEOS_MAKE_PATH)/aggregate.mk
