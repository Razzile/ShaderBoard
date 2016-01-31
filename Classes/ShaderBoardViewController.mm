/**********ShaderBoard*********/
/*Created by Satori & iNoahDev*/
/******************************/

#import <OpenGLES/ES3/glext.h>
#include "ShaderBoardViewController.h"
#include "ShaderBoardPrefs.h"

float _time;

static GLfloat const ShaderQuad[8] = {
    -1, -1,
    -1,  1,
     1, -1,
     1,  1
};

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredFramesPerSecond = 60;

    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];

    // Set up view
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = context;

    NSString *vertexShader = [NSString stringWithFormat:@"%@/Shaders/Base.vsh", kRootDir];
    NSString *fragmentShader = [NSString stringWithFormat:@"%@/Shaders/Gradient.fsh", kRootDir]; //change me

    self.shader = [[Shader alloc] initWithVertexShader:vertexShader andFragmentShader:fragmentShader];
    [self.shader addAttribute:@"position"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // glClearColor(0, 0, 0, 1);
    // glClear(GL_COLOR_BUFFER_BIT);
    // [self.shader renderInRect:rect atTime:self.timeSinceFirstResume];

    glClearDepthf(1.0);
    //Clear the color and depth buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glBindProgramPipelineEXT(self.shader.pipeline);

    GLuint timeLocation = [self.shader getUniformLocation:@"time"];
    glUniform1f(timeLocation, self.timeSinceFirstResume);

    GLuint res = [self.shader getUniformLocation:@"resolution"];
    glUniform2f(res, CGRectGetWidth(rect), CGRectGetHeight(rect));

    GLuint attribAddr = [self.shader getAttribLocation:@"position"];
    glEnableVertexAttribArray(attribAddr);
    glVertexAttribPointer(attribAddr, 2, GL_FLOAT, GL_FALSE, 0, ShaderQuad);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
