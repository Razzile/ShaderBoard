#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

@interface SBWallpaperController : NSObject
+ (instancetype)sharedInstance;
@end

@interface SBDisplayItem : NSObject <NSCopying>
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *displayIdentifier;
@end

@interface SBDeckSwitcherPageView : UIView
@property(nonatomic, strong) UIView *view;
@property(nonatomic, strong) SBDisplayItem *displayItem;
@end
