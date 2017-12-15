//
//  GSCameraRenderer.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//


#import "FDShaderProgram.h"
#import "GSMediaRenderer.h"

@interface GSCameraRenderer : GSMediaRenderer{
    FDShaderProgram *_shaderProgram;
    EAGLContext *openglContext;
}

-(instancetype)initWithContext:(EAGLContext *)glContext opengProgram:(FDShaderProgram *)faceDetectionProgram;


@end
