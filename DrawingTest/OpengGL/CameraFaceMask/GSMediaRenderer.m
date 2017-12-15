//
//  GSMediaRenderer.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GSMediaRenderer.h"

@implementation GSMediaRenderer
-(instancetype)init{
    self = [super init];
    
    return self;
}

- (GLuint)setupTexture:(UIImage *)stickerImage {
    // 1
    CGImageRef stickerImageRef = stickerImage.CGImage;
    if (!stickerImageRef) {
        NSLog(@"Failed to load image");
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(stickerImageRef);
    size_t height = CGImageGetHeight(stickerImageRef);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width,
                                                       height, 8, width * 4,
                                                       CGImageGetColorSpace(stickerImageRef),
                                                       kCGImageAlphaPremultipliedLast);
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), stickerImageRef);
    CGContextRelease(spriteContext);
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}
@end
