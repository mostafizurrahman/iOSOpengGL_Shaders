//
//  FDShaderProgram.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/15/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "ShaderBaseProgram.h"

@interface FDShaderProgram : ShaderBaseProgram{
    
    
    
    
    //uniform of aditional image textures
    GLuint u_textureAnimBackground;
    GLuint u_textureAnimationFrame;
    GLuint u_textureSticker;
    
    //uniforms of face detection rectangle
    GLuint u_faceRect;
    GLuint u_faceAngle;
    
    
    
}


@property (readonly) GLuint u_textureAnimBackground;
@property (readonly) GLuint u_textureAnimationFrame;
@property (readonly) GLuint u_textureSticker;

//uniforms of face detection rectangle
@property (readonly) GLuint u_faceRect;
@property (readonly) GLuint u_faceAngle;
@end
