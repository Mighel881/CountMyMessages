ARCHS = armv7 arm64
# TARGET = iphone:clang:10.2:10.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CountMyMessages
CountMyMessages_FILES = Tweak.xm $(wildcard FMDB/*.m)
CountMyMessages_FRAMEWORKS = Foundation UIKit
CountMyMessages_PRIVATE_FRAMEWORKS = ChatKit
CountMyMessages_LDFLAGS=-lsqlite3

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS"
