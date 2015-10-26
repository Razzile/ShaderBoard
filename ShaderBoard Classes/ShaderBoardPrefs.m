/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#import "ShaderBoardPrefs.h"

static CFDictionaryRef LoadPreferences();
static void PreferencesChanged();

@interface ShaderBoardPrefs ()
- (void)updatePrefs:(NSDictionary *)prefs;
@end

@implementation ShaderBoardPrefs

+ (instancetype)currentPrefs {
    LoadPreferences();
    static ShaderBoardPrefs *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // init prefs callback
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        (CFNotificationCallback)PreferencesChanged,
                                        CFSTR("ShaderBoardPreferencesChangedNotification"),
                                        NULL,
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
        inst = [ShaderBoardPrefs new];
    });
    inst.prefs = (__bridge NSDictionary *)LoadPreferences();
    return inst;
}

- (id)valueForKey:(NSString *)key {
    return [self.prefs valueForKey:key];
}

- (void)updatePrefs:(NSDictionary *)prefs {
    self.prefs = prefs;
}

static CFStringRef applicationID = CFSTR("com.noah.shaderboard");

static CFDictionaryRef LoadPreferences() {
    CFPreferencesAppSynchronize(applicationID);

    CFArrayRef keyList = CFPreferencesCopyKeyList(applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ?:  CFArrayCreate(NULL, NULL, 0, NULL);
    CFDictionaryRef prefs = CFPreferencesCopyMultiple(keyList, applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    CFRelease(keyList);
    return prefs;
}

static void PreferencesChanged() {
    ShaderBoardPrefs *prefs = [ShaderBoardPrefs currentPrefs];
    [prefs updatePrefs:(__bridge NSDictionary *)LoadPreferences()];
}

@end
