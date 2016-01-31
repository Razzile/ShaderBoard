//
//  Shader.h
//  ShaderBoard
//
//  Created by Satori on 30/09/2015.
//  Copyright © 2015 Satori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface Shader : NSObject

@property (nonatomic, retain) NSString *vertexShader;
@property (nonatomic, retain) NSString *fragmentShader;
@property GLuint vertexProgram;
@property GLuint fragmentProgram;
@property GLuint pipeline;

- (instancetype)initWithVertexShader:(NSString *)vsh andFragmentShader:(NSString *)fsh;
- (GLuint)getUniformLocation:(NSString *)uniform;
- (GLuint)getAttribLocation:(NSString *)attrib;
- (void)addAttribute:(NSString *)attrib;
// - (NSString *)linkLog;
// - (NSString *)compileLog;
@end
