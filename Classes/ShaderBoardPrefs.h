/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#define kRootDir @"/Library/Application Support/ShaderBoard"

@interface ShaderBoardPrefs : NSObject
@property (nonatomic, retain) NSDictionary *prefs;

+ (instancetype)currentPrefs;
- (id)valueForKey:(NSString *)key;
@end
