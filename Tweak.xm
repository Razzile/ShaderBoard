/*******************************/
/**********ShaderBoard**********/
/*Created by Satori & RickHaks */
/*******************************/

#include <substrate.h>
#include <UIKit/UIKit.h>

@interface SBWallpaperController : NSObject
- (id)initWithOrientation:(long long)arg1 variant:(long long)arg2;
@end
typedef struct {
    long long startStyle;
    long long endStyle;
    double transitionFraction;
} SBWallpaperTransitionState;

%hook SBWallpaperController

// - (id)initWithOrientation:(long long)arg1 variant:(long long)arg2 {
//     self = %orig;
//
//     void (^replaceWallpaperView)(UIView *) = ^(UIView *wallpaperView) {
//         /* TODO: change test view to shader view */
//         UIView *test = [[UIView alloc] initWithFrame:wallpaperView.frame];
//         test.backgroundColor = [UIColor redColor];
//         [wallpaperView addSubview:test];
//     };
//
//     if (self) {
//         UIView *sharedWallpaperView = MSHookIvar<UIView *>(self, "_sharedWallpaperView");
//         if (!sharedWallpaperView) {
//             UIView *lockscreenWallpaperview = MSHookIvar<UIView *>(self, "_lockscreenWallpaperView");
//             UIView *homescreenWallpaperview = MSHookIvar<UIView *>(self, "_homescreenWallpaperView");
//
//             replaceWallpaperView(lockscreenWallpaperview);
//             replaceWallpaperView(homescreenWallpaperview);
//         }
//         else {
//             replaceWallpaperView(sharedWallpaperView);
//         }
//         UIView *lockscreenEffectView = MSHookIvar<UIView *>(self, "_lockscreenEffectView");
//         UIView *homescreenEffectView = MSHookIvar<UIView *>(self, "_homescreenEffectView");
//
//         if (lockscreenEffectView) replaceWallpaperView(lockscreenEffectView);
//         if (homescreenEffectView) replaceWallpaperView(homescreenEffectView);
//     }
//     return self;
// }

- (id)_newWallpaperEffectViewForVariant:(long long)arg1 transitionState:(SBWallpaperTransitionState)arg2 {
    UIView *orig = %orig;
    UIView *test = [[UIView alloc] initWithFrame:orig.frame];
    test.backgroundColor = [UIColor redColor];
    [orig addSubview:test];
    return orig;
}

- (id)_wallpaperViewForVariant:(long long)arg1 {
    UIView *orig = %orig;
    UIView *test = [[UIView alloc] initWithFrame:orig.frame];
    test.backgroundColor = [UIColor redColor];
    [orig addSubview:test];
    return orig;
}

%end
