TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = bootsound.preference

bootsound.preference_FILES = PDPRootListController.m
bootsound.preference_FRAMEWORKS = UIKit
bootsound.preference_PRIVATE_FRAMEWORKS = Preferences
bootsound.preference_INSTALL_PATH = /Library/PreferenceBundles
bootsound.preference_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
