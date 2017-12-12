//
//  GLProgramInterface.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/13/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#define PRG_TYPE @"glsl"
#define GL_ERR (GLuint)(-1)

typedef enum{
    BaseTextureTypeYUV,
    BaseTextureTypeRGB
}BaseTextureType;

@protocol GLProgramInterface < NSObject>
@required
-(instancetype)initWithVShader:(NSString *)vshaderName
            withFragmentShader:(NSString *)fshaderName
                   textureType:(BaseTextureType)t_type;
-(void)useAttribute:(NSString *)attributeName;
-(void)useUniform:(NSString*)uniformName;
-(GLuint)getProgramHandler;
-(NSString *)checkGLError;

@end
