//
//  GSAnimationRenderer.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSCameraRenderer.h"
#import "FDAnimationData.h"




@interface GSAnimationRenderer : GSMediaRenderer{
    FDAnimationData *_animationData;
    GLuint backgroundTextureID;
    GLuint frameImageTextureID;
}

-(instancetype)initWithProgram:(FDShaderProgram *)shaderProgram;

-(void)changeAnimation:(FDAnimationData *)animationData;

@end
