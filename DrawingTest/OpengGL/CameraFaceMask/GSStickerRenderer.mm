//
//  GSStickerRenderer.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GSStickerRenderer.h"

@implementation GSStickerRenderer

-(instancetype)initWithProgram:(FDShaderProgram *)shaderProgram{
    self = [super init];
    _shaderProgram = shaderProgram;
    
    return self;
}

-(void)uploadStickerImage:(UIImage *)stickerImage{
    [super deleteTexture:&stickerTextureID];
    stickerTextureID = [super setupTexture:stickerImage];
    [super setTextParameters];
    NSLog(@"image tx id for sticekr %u", stickerTextureID);
}

-(void)updateStickerFrame:(const float[4])stickerFrame{
    glEnableVertexAttribArray(_shaderProgram.u_faceRect);
    glProgramUniform4fvEXT([_shaderProgram getProgramHandler],
                           _shaderProgram.u_faceRect, 1, stickerFrame);
}

-(void)updateStickerAngle:(const float)faceAngle{
    glEnableVertexAttribArray(_shaderProgram.u_faceRect);
    glUniform1f(_shaderProgram.u_faceRect, faceAngle);
}

-(void)renderSticker{
    [super renderTexture:stickerTextureID atIndex:STICKER_TEXTURE_UNIT
         uniformLocation:_shaderProgram.u_textureSticker];
}



@end
