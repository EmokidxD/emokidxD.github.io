export ARCHS = arm64 arm64e
#export TARGET = iphone:latest:15.2

INSTALL_TARGET_PROCESSES = SpringBoard
TWEAK_NAME = BootSound
$(TWEAK_NAME)_FILES = Tweak.x

SUBPROJECTS += bootsoundprefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
