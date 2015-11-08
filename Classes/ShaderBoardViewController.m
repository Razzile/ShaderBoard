/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#include "ShaderBoardViewController.h"
#include "ShaderBoardPrefs.h"

@implementation ShaderBoardViewController

@synthesize shader, displayLink;

+ (instancetype)sharedInstance {
    static id inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[ShaderBoardViewController alloc] init];
    });
    return inst;
}

- (id)init {
    if (self = [super init]) {
        self.preferredFramesPerSecond = 0;

        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:context];

        // Set up view
        GLKView *glkView = (GLKView *)self.view;
        glkView.context = context;
        glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
        glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        glkView.drawableStencilFormat = GLKViewDrawableStencilFormat8;
        glkView.drawableMultisample = GLKViewDrawableMultisample4X;
        glkView.enableSetNeedsDisplay = NO;

        self.displayLink = [CADisplayLink displayLinkWithTarget:glkView selector:@selector(display)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

        //NSString *fshName = [[ShaderBoardPrefs currentPrefs] valueForKey:@"kFragmentShader"];
        NSString *vertexShader = [NSString stringWithFormat:@"%@/Shaders/Base.vsh", kRootDir];
        NSString *fragmentShader = [NSString stringWithFormat:@"%@/Shaders/Gradient.fsh", kRootDir]; //change me

        self.shader = [[Shader alloc] initWithVertexShader:vertexShader andFragmentShader:fragmentShader];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.shader renderInRect:rect atTime:self.timeSinceFirstResume];
    glFinish();
}

@end
