ARCHS = armv7 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SmallSiri
SmallSiri_FILES = Tweak.xm
SmallSiri_FRAMEWORKS = UIKit
SmallSiri_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += smallsiri
include $(THEOS_MAKE_PATH)/aggregate.mk