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
    
}
@end


@implementation GSCameraRenderer
-(instancetype)initWithContext:(EAGLContext *)glContext opengProgram:(FDShaderProgram *)faceDetectionProgram{
    self = [super init];
    openglContext = glContext;
    _shaderProgram = faceDetectionProgram;
    _stickerRenderer = [[GSStickerRenderer alloc] initWithProgram:_shaderProgram];
    _animationRenderer = [[GSAnimationRenderer alloc] initWithProgram:_shaderProgram];

    return self;
}


@end
