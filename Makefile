export SDKVERSION=4.0

include theos/makefiles/common.mk

TWEAK_NAME = ActivatorDemo
ActivatorDemo_FILES = Tweak.xm
ActivatorDemo_FRAMEWORKS = UIKit
ActivatorDemo_LDFLAGS = -lactivator

include $(FW_MAKEDIR)/tweak.mk
