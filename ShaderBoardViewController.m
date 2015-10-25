/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#include "ShaderBoardViewController.h"
#include "ShaderBoardPrefs.h"

@implementation ShaderBoardViewController

@synthesize shader;

+ (instancetype)sharedInstance {
    static id inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[ShaderBoardViewController alloc] init];
    });
    return inst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredFramesPerSecond = 0;

    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];

    // Set up view
    GLKView *glkView = (GLKView *)self.view;
    glkView.enableSetNeedsDisplay = NO;
    glkView.context = context;

    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.frameInterval = 2;
    glClearColor(49/255, 192/255, 190/255, 1);

    //NSString *fshName = [[ShaderBoardPrefs currentPrefs] valueForKey:@"kFragmentShader"];
    NSString *vertexShader = [NSString stringWithFormat:@"%@/Shaders/Base.vsh", kRootDir];
    NSString *fragmentShader = [NSString stringWithFormat:@"%@/Shaders/Gradient.fsh", kRootDir]; //change me

    self.shader = [[Shader alloc] initWithVertexShader:vertexShader andFragmentShader:fragmentShader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)render:(CADisplayLink*)displayLink {
    GLKView* view = (GLKView*)self.view;
    [view display];
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    [self.shader renderInRect:rect atTime:self.timeSinceFirstResume];
}

@end
