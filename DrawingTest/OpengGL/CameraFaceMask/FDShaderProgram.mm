//
//  FDShaderProgram.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "FDShaderProgram.h"

@implementation FDShaderProgram



-(instancetype)initWithVShader:(NSString *)vshaderName
            withFragmentShader:(NSString *)fshaderName
                   textureType:(BaseTextureType)t_type{
    
    self = [super initWithVShader:vshaderName withFragmentShader:fshaderName textureType:t_type];
    
    [self setupTextureUniforms];
    
    [self setupFaceDetectionUniforms];
    
    return self;
}

-(void)setupTextureUniforms{
    u_textureAnimBackground = glGetUniformLocation([self getProgramHandler], "u_TextureAnimBackground");
    [self.uniformDictionary setObject:[NSNumber numberWithInteger:u_textureAnimBackground]
                               forKey:@"u_TextureAnimBackground"];
    u_textureAnimationFrame = glGetUniformLocation([self getProgramHandler], "u_TextureAnimationFrame");
    [self.uniformDictionary setObject:[NSNumber numberWithInteger:u_textureAnimationFrame]
                               forKey:@"u_TextureAnimationFrame"];
}

-(void)setupFaceDetectionUniforms{
    u_faceRect = glGetUniformLocation([self getProgramHandler], "u_faceRectangle");
    [self.attributeDictionary setObject:[NSNumber numberWithInteger:u_faceRect] forKey:@"u_faceRectangle"];
    u_faceAngle = glGetUniformLocation([self getProgramHandler], "u_faceAngle");
    [self.attributeDictionary setObject:[NSNumber numberWithInteger:u_faceAngle] forKey:@"u_faceAngle"];
}



@end
