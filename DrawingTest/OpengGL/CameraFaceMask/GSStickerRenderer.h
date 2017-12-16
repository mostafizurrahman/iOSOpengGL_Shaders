//
//  GSStickerRenderer.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSCameraRenderer.h"
#import "GSMediaRenderer.h"

@interface GSStickerRenderer : GSMediaRenderer{
    GLuint stickerTextureID;
}

-(instancetype)initWithProgram:(FDShaderProgram *)shaderProgram;
-(void)uploadStickerImage:(UIImage *)stickerImage;
-(void)updateStickerFrame:(const float[4])stickerFrame;
-(void)updateStickerAngle:(const float)faceAngle;
-(void)renderSticker;
@end
