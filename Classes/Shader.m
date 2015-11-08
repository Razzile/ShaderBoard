//
//  Shader.m
//  OpenGLTest
//
//  Created by callum taylor on 30/09/2015.
//  Copyright © 2015 callum. All rights reserved.
//

#import "Shader.h"
#import <GLKit/GLKit.h>

static GLfloat const ShaderQuad[8] = {
    -1, -1,
    -1,  1,
     1, -1,
     1,  1
};

@interface Shader ()
// Program
@property (nonatomic, assign, readonly) GLuint program;

// Attribute Handles
@property (assign, nonatomic, readonly) GLuint aPosition;
@property (assign, nonatomic) GLuint attribCount;
// Uniform Handles
@property (assign, nonatomic, readonly) GLuint uResolution;
@property (assign, nonatomic, readonly) GLuint uTime;
@end

@implementation Shader

- (instancetype)initWithVertexShader:(NSString *)vsh andFragmentShader:(NSString *)fsh {
    self = [super init];

    if (self) {
        // Program
        _program = [self programWithVertexShader:vsh fragmentShader:fsh];

        // Attributes
        [self addAttribute:@"position"];
        _aPosition = glGetAttribLocation(_program, "position");

        // Uniforms
        _uResolution = glGetUniformLocation(_program, "resolution");
        _uTime = glGetUniformLocation(_program, "time");

        // Configure OpenGL ES
        [self configureOpenGLES];
    }

    return self;

}

- (void)renderInRect:(CGRect)rect atTime:(NSTimeInterval)time {
    // Uniforms
    [self use];
    glUniform2f(self.uResolution, CGRectGetWidth(rect)*2.f, CGRectGetHeight(rect)*2.f);
    glUniform1f(self.uTime, time);

    // Draw
    glDrawArrays(GL_TRIANGLES, 0, 4);
    [self unuse];
}

#pragma mark - Private
#pragma mark - Configurations
- (void)configureOpenGLES {
    // Program
    glUseProgram(_program);
    // Attributes
    glEnableVertexAttribArray(_aPosition);
    glVertexAttribPointer(_aPosition, 2, GL_FLOAT, GL_FALSE, 0, ShaderQuad);
}

- (void)addAttribute:(NSString *)attribute {
    glBindAttribLocation(_program, self.attribCount++, [attribute UTF8String]);
}

- (void)use {
    glUseProgram(_program);
    //enable all the attributes we added with addAttribute
    for (int i = 0; i < self.attribCount; i++) {
        glEnableVertexAttribArray(i);
    }
}

- (void)unuse {
    glUseProgram(0);
    //enable all the attributes we added with addAttribute
    for (int i = 0; i < self.attribCount; i++) {
        glDisableVertexAttribArray(i);
    }
}

#pragma mark - Compile & Link
- (GLuint)programWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh {
    // Build shaders
    GLuint vertexShader = [self shaderWithName:vsh type:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self shaderWithName:fsh type:GL_FRAGMENT_SHADER];

    // Create program
    GLuint programHandle = glCreateProgram();

    // Attach shaders
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);

    // Link program
    glLinkProgram(programHandle);

    // Check for errors
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[1024];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%@:- GLSL Program Error: %s", [self class], messages);
    }

    // Delete shaders
    glDetachShader(programHandle, vertexShader);
    glDetachShader(programHandle, fragmentShader);
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    return programHandle;
}

- (GLuint)shaderWithName:(NSString*)name type:(GLenum)type {
    // Load the shader file
    NSString* file = name;

    // Create the shader source
    const GLchar* source = (GLchar*)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];

    // Create the shader object
    GLuint shaderHandle = glCreateShader(type);

    // Load the shader source
    glShaderSource(shaderHandle, 1, &source, 0);

    // Compile the shader
    glCompileShader(shaderHandle);

    // Check for errors
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%@:- GLSL Shader Error: %s", [self class], messages);
    }

    return shaderHandle;
}

@end
