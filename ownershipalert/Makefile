include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = OwnershipAlert
OwnershipAlert_FILES = osaRootListController.m
OwnershipAlert_INSTALL_PATH = /Library/PreferenceBundles
OwnershipAlert_FRAMEWORKS = UIKit
OwnershipAlert_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OwnershipAlert.plist$(ECHO_END)
