//
//  Shader.h
//  ShaderBoard
//
//  Created by Satori on 30/09/2015.
//  Copyright © 2015 Satori. All rights reserved.
//

#import <OpenGLES/ES3/glext.h>
#import "Shader.h"

#define LOAD_CONTENTS(x) (GLchar *)[[NSString stringWithContentsOfFile:x encoding:NSUTF8StringEncoding error:nil] UTF8String];

@implementation Shader
- (instancetype)initWithVertexShader:(NSString *)vsh andFragmentShader:(NSString *)fsh {
    self = [super init];
    if (self) {
        const GLchar *vertexSourceText = LOAD_CONTENTS(vsh);
        const GLchar *fragmentSourceText = LOAD_CONTENTS(fsh);

        self.vertexProgram = glCreateShaderProgramvEXT(GL_VERTEX_SHADER, 1, &vertexSourceText);

        self.fragmentProgram =  glCreateShaderProgramvEXT(GL_FRAGMENT_SHADER, 1, &fragmentSourceText);

        // Construct a program pipeline object and configure it to use the shaders
        GLuint pipeline = 0;
        glGenProgramPipelinesEXT(1, &pipeline);
        glBindProgramPipelineEXT(pipeline);
        glUseProgramStagesEXT(pipeline, GL_VERTEX_SHADER_BIT_EXT, self.vertexProgram);
        glUseProgramStagesEXT(pipeline, GL_FRAGMENT_SHADER_BIT_EXT, self.fragmentProgram);
        self.pipeline = pipeline;
    }
    return self;
}

- (GLuint)getUniformLocation:(NSString *)uniform {
    return glGetUniformLocation(self.fragmentProgram, [uniform UTF8String]);
}

- (GLuint)getAttribLocation:(NSString *)attrib {
    return glGetAttribLocation(self.vertexProgram, [attrib UTF8String]);
}

- (void)addAttribute:(NSString *)attribute {
    static int count = 0;
    glBindAttribLocation(self.vertexProgram, count++, [attribute UTF8String]);
}

@end
