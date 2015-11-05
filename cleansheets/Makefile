include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CleanSheets
CleanSheets_FILES = cleansheetsRootListController.m SKPersonCell.m
CleanSheets_INSTALL_PATH = /Library/PreferenceBundles
CleanSheets_FRAMEWORKS = UIKit Social
CleanSheets_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CleanSheets.plist$(ECHO_END)
