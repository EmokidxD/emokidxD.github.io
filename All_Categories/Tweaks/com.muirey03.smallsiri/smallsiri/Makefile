include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = smallsiri
smallsiri_FILES = XXXRootListController.m
smallsiri_INSTALL_PATH = /Library/PreferenceBundles
smallsiri_FRAMEWORKS = UIKit
smallsiri_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/smallsiri.plist$(ECHO_END)
