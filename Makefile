include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Popover8
Popover8_FILES = tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

Popover8_FRAMEWORKS= UIKIT

after-install::
	install.exec "killall SpringBoard"