/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Metal/Metal.h>
#import <UIKit/UIKit.h>
#import <substrate.h>

#import "Interfaces.h"

#define SHPref(prefs, key, default) !CFDictionaryGetValue(prefs, key) ? default : CFDictionaryGetValue(prefs, key)
#define SHPrefBool(prefs, key, default) !CFDictionaryGetValue(prefs, key) ? CFBooleanRef(default) : CFBooleanRef(CFDictionaryGetValue(prefs, key))
#define SHPrefString(prefs, key, default) !CFDictionaryGetValue(prefs, key) ? CFStringCreateWithCString(kCFAllocatorDefault, default, kCFStringEncodingUTF8) : CFStringRef(CFDictionaryGetValue(prefs, key))

#define SHPrefs(key, default) SHPref(prefs, key, default)
#define SHPrefsBool(key, default) SHPrefBool(prefs, key, default)
#define SHPrefsString(key, default) SHPrefString(prefs, key, default)

typedef struct {
    long long startStyle;
    long long endStyle;
    double transitionFraction;
} SBWallpaperTransitionState;

#if __LP64__
  static id<MTLDevice> device = MTLCreateSystemDefaultDevice();
#endif

static CFStringRef applicationID = CFSTR("com.noah.shaderboard");
static CFDictionaryRef prefs = NULL;

static void LoadPreferences() {
    CFPreferencesAppSynchronize(applicationID);

    static CFArrayRef keyList = CFPreferencesCopyKeyList(applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ?:  CFArrayCreate(NULL, NULL, 0, NULL);
    prefs = CFPreferencesCopyMultiple(keyList, applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    CFRelease(keyList);
}

static void PreferencesChanged() {
    static CFDictionaryRef oldPrefs = prefs;
    LoadPreferences();

    if (!CFEqual(SHPrefString(oldPrefs, "kShaderFileDirectory", ""), SHPrefsString("kShaderFileDirectory", ""))) {
        //TODO:
    }
}

%hook SBWallpaperController
- (void)_handleWallpaperChangedForVariant:(int)variant {
    %orig();

    static UIView *_wallpaperView = MSHookIvar<UIView *>(self, "_sharedWallpaperView");
    if (!_wallpaperView) {
        _wallpaperView = MSHookIvar<UIView *>(self, "_homescreenWallpaperView");
    }

    HBLogDebug(@"[ShaderBoard] SharedWallpaperView: %@", _wallpaperView);

    static UIView *view = [[UIView alloc] initWithFrame:_wallpaperView.frame];
    view.backgroundColor = [UIColor redColor];

    [_wallpaperView addSubview:view];
}

- (void)willAnimateRotationToInterfaceOrientation:(int)orientation duration:(double)duration {
    %orig();

    static SBWallpaperController *controller = [%c(SBWallpaperController) sharedInstance];
    static UIView *_wallpaperView = MSHookIvar<UIView *>(controller, "_sharedWallpaperView");

    if (!_wallpaperView) {
        _wallpaperView = MSHookIvar<UIView *>(controller, "_homescreenWallpaperView");
    }

    static UIView *view = [_wallpaperView.subviews lastObject];
    view.frame = _wallpaperView.subviews[0].frame;
}
%end

//TODO: Fix Crashes on 2nd'3rd/4th launch of app switcher
%hook SBDeckSwitcherPageView
 - (void)setView:(UIView *)view animated:(BOOL)animated {
    %orig();

    static UIView *wallpaper = MSHookIvar<UIView *>(self.view, "_wallpaperEffectView");
    if (![wallpaper isKindOfClass:%c(SBWallpaperEffectView)]) {
        return;
    }

    static UIView *shaderView = [[UIView alloc] initWithFrame:wallpaper.frame];

    //fucking...
    if ([shaderView isKindOfClass:[UIView class]])
        shaderView.backgroundColor = [UIColor blueColor];

    if (![wallpaper.subviews containsObject:shaderView])
        [wallpaper addSubview:shaderView];
}
%end

%hook SBDockView
- (id)initWithDockListView:(id)docklistView forSnapshot:(char)snapshot {
    id orig = %orig();

    static UIView *_backgroundView = MSHookIvar<UIView *>(self, "_backgroundView");
    static UIView *test = [[UIView alloc] initWithFrame:_backgroundView.frame];
    test.backgroundColor = [UIColor redColor];
    [_backgroundView addSubview:test];

    return orig;
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)PreferencesChanged,
                                    CFSTR("ShaderBoardPreferencesChangedNotification"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    LoadPreferences();
}

%dtor {
    //remove wallpaper
    static SBWallpaperController *controller = [%c(SBWallpaperController) sharedInstance];
    static UIView *wallpaper = MSHookIvar<UIView *>(controller, "_sharedWallpaperView");

    if (!wallpaper) {
        wallpaper = MSHookIvar<UIView *>(controller, "_homescreenWallpaperView");
    }

    //better way to remove our custom wallpaper?
    [wallpaper.subviews[1] removeFromSuperview];

    if (prefs)
      CFRelease(prefs);
}
