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
    glBindTexture(GL_TEXTURE_2D, stickerTextureID);
    glDeleteTextures(1, &stickerTextureID);
    stickerTextureID = 0;
    stickerTextureID = [super setupTexture:stickerImage];
    NSLog(@"image tx id for sticekr %u", stickerTextureID);
}

-(void)updateStickerFrame:(const float[4])stickerFrame{
    GLuint faceBoundUniform = [[_shaderProgram.uniformDictionary objectForKey:@"u_faceRectangle"]
                           unsignedIntValue];
    glProgramUniform4fvEXT([_shaderProgram getProgramHandler],
                           faceBoundUniform, 1, stickerFrame);
}

-(void)updateStickerAngle:(const float)faceAngle{
    
    GLuint angleUniform = [[_shaderProgram.uniformDictionary objectForKey:@"u_faceAngle"]
                           unsignedIntValue];
    
    glUniform1f(angleUniform, faceAngle);
}

-(void)renderSticker{
    
}



@end
