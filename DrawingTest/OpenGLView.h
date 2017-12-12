//
//  OpenGLView.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 10/25/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextureLoader.h"

@interface OpenGLView : UIView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    CIContext *cicontext;
    
    GLuint _colorRenderBuffer;
    GLuint programHandle;
    
    GLuint _texCoordSlot;
    GLuint _textureUniform;
    GLuint _textureFloorUniform;
    GLuint _textureTopUniform;
    
    GLuint _blur_h;
    GLuint _blur_v;
    GLuint _positionSlot;
    GLuint _colorSlot;
    
    GLuint _floorTexture;
    GLuint _bwTexture;
    GLuint _brushTexture;
    
    GLuint resolution;
    GLuint blur_radius;
    GLuint direction;
    
    GLuint vertexBuffer;
    GLuint indexBuffer;
    GLuint _vertexBuffer2;
    GLuint _indexBuffer2;
    
    GLint defaultFrameBuffer;
    GLuint framebuffer;
    
    GLubyte *textureData;
    TextureLoader *textureLoader;
    
    
    
    
    
    
    TextureLoader* offscreenTextureLoader;
    
    GLuint offscreenToOnscreenTextureCoordLoc;
    GLuint offscreenToOnscreenVertexLoc;
    GLuint offscreenToOnscreenTexture;
    GLuint offscreenToOnscreenShaderProgram;
    GLuint offscreenToOnscreenVertexBufferID;
    GLuint offscreenToOnscreenIndexBufferID;
}
-(UIImage *)getGLImage;
@end
