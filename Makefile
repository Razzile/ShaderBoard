include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ShaderBoard
ShaderBoard_FILES = Tweak.xm
ShaderBoard_FRAMEWORKS = UIKit QuartzCore Metal

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
