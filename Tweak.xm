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
#import "ShaderBoardViewController.h"

#define ghetto /*huehuhe*/

typedef struct {
    long long startStyle;
    long long endStyle;
    double transitionFraction;
} SBWallpaperTransitionState;


static ghetto void replaceWallpaper(UIView *wallpaperView) {
    ShaderBoardViewController *vc = [ShaderBoardViewController sharedInstance];
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

%end

%hook SBWallpaperEffectView
- (void)layoutSubviews {
    %orig();
    replaceWallpaper(self);
}
%end
