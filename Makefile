include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ShaderBoard
ShaderBoard_FILES = Tweak.xm $(wildcard ./*.m)
ShaderBoard_FRAMEWORKS = UIKit QuartzCore GLKit OpenGLES
ShaderBoard_ADDITIONAL_CFLAGS += -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
