/*******************************/
/**********ShaderBoard**********/
/*Created by Satori & RickHaks */
/*******************************/

#include <substrate.h>
#include <UIKit/UIKit.h>

@interface SBWallpaperController : NSObject
- (id)initWithOrientation:(long long)arg1 variant:(long long)arg2;
@end

%hook SBWallpaperController

- (id)initWithOrientation:(long long)arg1 variant:(long long)arg2 {
    self = %orig;
    
    void (^replaceWallpaperView)(UIView *) = ^(UIView *wallpaperView) {
        /* TODO: change test view to shader view */
        UIView *test = [[UIView alloc] initWithFrame:wallpaperView.frame];
        test.backgroundColor = [UIColor redColor];
        [wallpaperView addSubview:test];
    };
    
    if (self) {
        UIView *sharedWallpaperView = MSHookIvar<UIWindow *>(self, "_sharedWallpaperView");
        if (!sharedWallpaperView) {
            UIView *lockscreenWallpaperview = MSHookIvar<UIWindow *>(self, "_lockscreenWallpaperView");
            UIView *homescreenWallpaperview = MSHookIvar<UIWindow *>(self, "_homescreenWallpaperView");

            replaceWallpaperView(lockscreenWallpaperview);
            replaceWallpaperView(homescreenWallpaperview);
        }
        else {
            replaceWallpaperView(sharedWallpaperView);
        }
    }
    return self;
}

%end

