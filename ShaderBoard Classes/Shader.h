//
//  Shader.h
//  OpenGLTest
//
//  Created by callum taylor on 30/09/2015.
//  Copyright © 2015 callum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Shader : NSObject

- (instancetype)initWithVertexShader:(NSString *)vsh andFragmentShader:(NSString *)fsh;
- (void)renderInRect:(CGRect)rect atTime:(NSTimeInterval)time;

@end
