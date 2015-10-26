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
#import "Classes/ShaderBoardViewController.h"

typedef struct {
    long long startStyle;
    long long endStyle;
    double transitionFraction;
} SBWallpaperTransitionState;


static void replaceWallpaper(UIView *wallpaperView) {
    ShaderBoardViewController *vc = [ShaderBoardViewController sharedInstance];

    if (![wallpaperView.subviews containsObject:vc.view])
        [wallpaperView addSubview:vc.view];
}

%hook SBWallpaperController
- (void)_handleWallpaperChangedForVariant:(int)variant {
    %orig();

    UIView *_sharedWallpaperView = MSHookIvar<UIView *>(self, "_sharedWallpaperView");
    if (_sharedWallpaperView) replaceWallpaper(_sharedWallpaperView);
    else {
        UIView *_homescreenWallpaperView = MSHookIvar<UIView *>(self, "_homescreenWallpaperView");
        UIView *_lockscreenWallpaperView = MSHookIvar<UIView *>(self, "_lockscreenWallpaperView");

        replaceWallpaper(_homescreenWallpaperView);
        replaceWallpaper(_lockscreenWallpaperView);
    }
}

- (id)_wallpaperViewForVariant:(long long)arg1 {
    UIView *orig = %orig();
    replaceWallpaper(orig);
    return orig;
}

- (id)_newWallpaperEffectViewForVariant:(long long)arg1 transitionState:(SBWallpaperTransitionState)arg2 {
    UIView *orig = %orig();
    replaceWallpaper(orig);
    return orig;
}

%end

// %hook SBDockView
// - (void)viewDidLoad {
//     %orig();
//
//     SBWallpaperEffectView *_backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
//     UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//     effectView.frame = _backgroundView.frame;
//     [_backgroundView.superview addSubview:effectView afterSubview:self];
//
//     [_backgroundView removeFromSuperview];
// }

%hook SBSwitcherWallpaperPageContentView
-(UIView *)wallpaperEffectView {
    UIView *orig = %orig();
    replaceWallpaper(orig);
    return orig;
}

%end
