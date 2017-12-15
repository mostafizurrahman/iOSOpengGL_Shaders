//
//  FDShaderProgram.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "FDShaderProgram.h"

@interface FDShaderProgram(){
    
}
@property (readwrite) GLuint u_textureAnimBackground;
@property (readwrite) GLuint u_textureAnimationFrame;
@property (readwrite) GLuint u_textureSticker;

//uniforms of face detection rectangle
@property (readwrite) GLuint u_faceRect;
@property (readwrite) GLuint u_faceAngle;
@end

@implementation FDShaderProgram

@synthesize u_textureAnimBackground;
@synthesize u_textureAnimationFrame;
@synthesize u_textureSticker;

@synthesize u_faceRect;
@synthesize u_faceAngle;

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
    u_textureSticker = glGetUniformLocation([self getProgramHandler], "u_TextureStickerTexture");
    [self.uniformDictionary setObject:[NSNumber numberWithInteger:u_textureSticker]
                               forKey:@"u_TextureStickerTexture"];
}

-(void)setupFaceDetectionUniforms{
    u_faceRect = glGetUniformLocation([self getProgramHandler], "u_faceRectangle");
    [self.attributeDictionary setObject:[NSNumber numberWithInteger:u_faceRect] forKey:@"u_faceRectangle"];
    u_faceAngle = glGetUniformLocation([self getProgramHandler], "u_faceAngle");
    [self.attributeDictionary setObject:[NSNumber numberWithInteger:u_faceAngle] forKey:@"u_faceAngle"];
}



@end
