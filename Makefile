include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ShaderBoard
ShaderBoard_FILES = Hooks.xm $(wildcard ./Classes/*.m)
ShaderBoard_FRAMEWORKS = UIKit QuartzCore GLKit OpenGLES
ShaderBoard_ADDITIONAL_CFLAGS += -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
