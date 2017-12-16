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
   
    GLuint cameraTextureID;
    EAGLContext *openglContext;
}

-(instancetype)initWithContext:(EAGLContext *)glContext opengProgram:(FDShaderProgram *)faceDetectionProgram;

-(void)renderCameraBuffer:(unsigned char*) cameraData;
-(void)generateTexture:(const CGSize)textureSize;
@end
