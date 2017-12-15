//
//  GSAnimationRenderer.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSCameraRenderer.h"




@interface GSAnimationRenderer : GSMediaRenderer{
    FDShaderProgram *_shaderProgram;
}

-(instancetype)initWithProgram:(FDShaderProgram *)shaderProgram;

@end
