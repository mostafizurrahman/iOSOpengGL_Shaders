//
//  TextureRenderer.m
//  IPVFaceDetectioniOS
//
//  Created by Nishu on 5/21/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "TextureLoader.h"
#import <GLKit/GLKit.h>

@interface TextureLoader() {
    GLuint texture;
    CGSize _textureSize;
}

@end

@implementation TextureLoader
-(instancetype)init {
    self = [super init];
    if (self) {
        texture = 0;
        _textureSize = CGSizeZero;
    }
    return self;
}


-(void)generateTexture {
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    [self setTextParameters];
}



-(void)setTextParameters{
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

-(void)generateTextureOfSize:(CGSize)textureSize{

    _textureSize = textureSize;
	[self generateTexture];
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureSize.width, textureSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, 0);
}

-(void)renderFramebufferToTexture:(GLuint)framebuffer{
	
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
	glBindTexture(GL_TEXTURE_2D, texture);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
	
}

-(BOOL)generateTexture:(NSString *)texturePath {
    NSError* error = nil;
    BOOL _generated = YES;
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:texturePath options:nil error:&error];
    if (!error) {
        // set texture name to current texture
        texture = textureInfo.name;
    } else {
        _generated = NO;
    }
    
    return _generated;
}

-(void)activeTexture:(short)textureUnit {
    glActiveTexture(GL_TEXTURE0 + textureUnit);
    glBindTexture(GL_TEXTURE_2D, texture);
}

-(void)uploadData:(GLubyte * )uploadData formMat:(GLuint)textureFormat{
    [self uploadData:uploadData size:_textureSize formMat:textureFormat];
}


-(void)uploadData:(GLubyte * )uploadData size:(CGSize )textureSize formMat:(GLuint)textureFormat
{
    
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, textureFormat, textureSize.width, textureSize.height, 0, textureFormat, GL_UNSIGNED_BYTE, uploadData);
    [self setTextParameters];
}

-(void)deleteTexture {
    glDeleteTextures(1, &texture);
    texture = 0;
}

-(void)dealloc {
    [self deleteTexture];
}

@end
