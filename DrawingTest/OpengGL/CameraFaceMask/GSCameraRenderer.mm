//
//  GSCameraRenderer.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GSStickerRenderer.h"
#import "GSCameraRenderer.h"
#import "GSAnimationRenderer.h"


@interface GSCameraRenderer (){
    GSAnimationRenderer *_animationRenderer;
    GSStickerRenderer *_stickerRenderer;
    CGSize _textureSize;
}
@end


@implementation GSCameraRenderer
-(instancetype)initWithContext:(EAGLContext *)glContext
                  opengProgram:(FDShaderProgram *)faceDetectionProgram{
    self = [super init];
    openglContext = glContext;
    _shaderProgram = faceDetectionProgram;
    _stickerRenderer = [[GSStickerRenderer alloc] initWithProgram:_shaderProgram];
    _animationRenderer = [[GSAnimationRenderer alloc] initWithProgram:_shaderProgram];
    return self;
}

-(void)generateTexture:(const CGSize)textureSize {
    _textureSize = textureSize;
    //generating an empty texture for camera
    glGenTextures(1, &cameraTextureID);
    glBindTexture(GL_TEXTURE_2D, cameraTextureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureSize.width,
                 textureSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, 0);
    [super setTextParameters];
}

-(void)renderCameraBuffer:(unsigned char*) cameraData{
    [super renderTexture:cameraTextureID atIndex:CAMERAF_TEXTURE_UNIT
         uniformLocation:_shaderProgram.u_BaseTextureRGB];
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, _textureSize.width,
                 _textureSize.height, 0, GL_RGB,
                 GL_UNSIGNED_BYTE, cameraData);
    [super setTextParameters];
}

@end
