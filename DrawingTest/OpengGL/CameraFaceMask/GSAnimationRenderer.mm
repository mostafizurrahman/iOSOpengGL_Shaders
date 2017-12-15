//
//  GSAnimationRenderer.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GSAnimationRenderer.h"

@implementation GSAnimationRenderer

-(instancetype)initWithProgram:(FDShaderProgram *)shaderProgram{
    self = [super init];

    _shaderProgram = shaderProgram;
    return self;
}


@end
