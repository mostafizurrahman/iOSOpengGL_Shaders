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
    
    //uniforms of face detection rectangle
    GLuint u_faceRect;
    GLuint u_faceAngle;
    
    
    
}



@end
