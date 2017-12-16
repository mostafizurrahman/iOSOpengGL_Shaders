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
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIDevice.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <CoreImage/CIDetector.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "BCDefinedConstant.h"


#define PRG_TYPE @"glsl"

#define GL_ERR (GLuint)(-1)

typedef enum{
    BaseTextureTypeYUV,
    BaseTextureTypeRGB
}BaseTextureType;

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} VertexData_t;

const GLubyte DefaultIndices[] = {
    0, 1, 2,
    2, 3, 0
};

#define STICKER_TEXTURE_UNIT 5
#define ANIMBGR_TEXTURE_UNIT 4
#define ANIMFRM_TEXTURE_UNIT 3
#define CAMERAF_TEXTURE_UNIT 2
#define DEFAULT_TEXTURE_UNIT 1

const VertexData_t DefaultVertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1.0}, {1, 1}},
    {{1, 1, 0}, {0, 1, 0, 1.0}, {1, 0}},
    {{-1, 1, 0}, {0, 0, 1, 1.0}, {0, 0}},
    {{-1, -1, 0}, {0, 0, 0, 1.0}, {0, 1}},
};

@protocol GLProgramInterface < NSObject>
@required
-(instancetype)initWithVShader:(NSString *)vshaderName
            withFragmentShader:(NSString *)fshaderName
                   textureType:(BaseTextureType)t_type;
-(void)useAttribute:(NSString *)attributeName;
-(void)useUniform:(NSString*)uniformName;
-(GLuint)getProgramHandler;
-(NSString *)checkGLError;
-(void)useShaderProgram;
@end
