//
//  GSAnimationRenderer.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GSAnimationRenderer.h"

@interface GSAnimationRenderer(){
    CGSize _textureSize;
    NSDate *currentDate;
    int currentFrameIndex;
    float currentFrameDelay;
}
@end
@implementation GSAnimationRenderer

-(instancetype)initWithProgram:(FDShaderProgram *)shaderProgram{
    self = [super init];
    
    _shaderProgram = shaderProgram;
    
    return self;
}

-(void)changeAnimation:(FDAnimationData *)animData{
    _animationData = animData;
    currentFrameIndex = 0;
    [self generateBackgroundTexture:animData.animBackground];
    
    [self renderBackground];
    [self renderFrameImage];
}

-(void)generateBackgroundTexture:(NSString *)bg_imageName{
    NSString *backgroundPath = [[NSBundle mainBundle]
                                pathForResource:bg_imageName
                                ofType:@"png"];
    UIImage *backgroundImage = [[UIImage alloc]
                                initWithContentsOfFile:backgroundPath];
    [super deleteTexture:&backgroundTextureID];
    backgroundTextureID = [super setupTexture:backgroundImage];
    [super setTextParameters];
    NSLog(@"image tx id for sticekr %u", backgroundTextureID);
}

-(void)renderBackground{
    
    [super renderTexture:backgroundTextureID atIndex:ANIMBGR_TEXTURE_UNIT
             uniformLocation:_shaderProgram.u_textureAnimBackground];
    
    [super setTextParameters];
}

-(void)renderFrameImage{

    if(_animationData.animationDuration <= currentFrameDelay){
        currentFrameDelay = 0;
        NSString *name = [NSString stringWithFormat:@"%@_%d.png",_animationData.animationName, currentFrameIndex];
        NSString *framePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        [super deleteTexture:&frameImageTextureID];
        if([self generateTexture:framePath]){
            [super renderTexture:frameImageTextureID atIndex:ANIMFRM_TEXTURE_UNIT
                 uniformLocation:_shaderProgram.u_textureAnimationFrame];
            [super setTextParameters];
        }
        currentFrameIndex = ++currentFrameIndex % _animationData.frameCount;
    }
}

-(BOOL)generateTexture:(NSString *)texturePath {
    NSError* error = nil;
    BOOL _generated = YES;
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:texturePath options:nil error:&error];
    if (!error) {
        // set texture name to current texture
        frameImageTextureID = textureInfo.name;
    } else {
        _generated = NO;
    }
    
    return _generated;
}


@end
