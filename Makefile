ARCHS = arm64

include $(THEOS)/makefiles/common.mk

SYSROOT = $(THEOS)/sdks/iPhoneOS10.3.sdk

TWEAK_NAME = OwnershipAlert
OwnershipAlert_FILES = Tweak.xm
OwnershipAlert_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += ownershipalert
include $(THEOS_MAKE_PATH)/aggregate.mk
