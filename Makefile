include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ShaderBoard
ShaderBoard_FILES = Hooks.xm $(wildcard ./Classes/*.m ./Classes/*.cpp ./Classes/*.mm)
ShaderBoard_FRAMEWORKS = UIKit QuartzCore GLKit OpenGLES
ShaderBoard_CFLAGS += -std=c++11
ShaderBoard_ADDITIONAL_CFLAGS += -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
