/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "Shader.h"

@interface ShaderBoardViewController : GLKViewController
@property (nonatomic, retain) Shader *shader;
@property (nonatomic, retain) CADisplayLink *displayLink;
+ (instancetype)sharedInstance;

@end
