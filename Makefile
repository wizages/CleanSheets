include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CleanSheets
CleanSheets_FILES = tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

CleanSheets_FRAMEWORKS= UIKIT


SUBPROJECTS += pref_clean
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall SpringBoard"