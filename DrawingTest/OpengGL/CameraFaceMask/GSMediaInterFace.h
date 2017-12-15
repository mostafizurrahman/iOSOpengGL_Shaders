//
//  GSMediaInterFace.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDShaderProgram.h"

@protocol GSMediaInterFace<NSObject>
@required
- (GLuint)setupTexture:(UIImage *)stickerImage;

@end
