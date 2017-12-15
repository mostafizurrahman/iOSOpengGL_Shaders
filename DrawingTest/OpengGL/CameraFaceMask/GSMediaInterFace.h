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
-(void)renderTexture:(GLuint)textureID
             atIndex:(const int)index
     uniformLocation:(const GLuint)locatoin;
-(void)setTextParameters;
-(void)deleteTexture:(GLuint *)textureID;
@end
