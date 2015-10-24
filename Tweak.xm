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


- (id)_wallpaperViewForVariant:(long long)arg1 {
    UIView *orig = %orig;
    UIView *test = [[UIView alloc] initWithFrame:orig.frame];
    test.backgroundColor = [UIColor redColor];
    [orig addSubview:test];
    return orig;
}

%end

%hook SBSwitcherWallpaperPageContentView

-(UIView *)wallpaperEffectView {
    UIView *orig = %orig;
    UIView *test = [[UIView alloc] initWithFrame:orig.frame];
    test.backgroundColor = [UIColor redColor];
    [orig addSubview:test];
    return orig;
}

%end
