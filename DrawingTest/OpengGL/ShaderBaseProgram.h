//
//  ShaderBaseProgram.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/13/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLProgramInterface.h"

@interface ShaderBaseProgram : NSObject<GLProgramInterface>{
    
    //FrameBuffer, RenderBuffer, VertexBuffer and IndeBuffer IDs
    GLuint base_indexBufferID;
    GLuint base_vertexBufferID;
    GLuint defaultFrameBufferID;
    GLuint renderBufferID;
    
}


-(instancetype)initWithVShader:(NSString *)vshaderName
            withFragmentShader:(NSString *)fshaderName
                   textureType:(BaseTextureType)t_type;
-(void)useUniform:(NSString *)uniformName;
-(void)useAttribute:(NSString *)attributeName;
-(GLuint)getProgramHandler;
-(NSString*)checkGLError;

@property (readonly) GLuint u_UVBaseTexture; // UV texture uniform for UV channel
@property (readonly) GLuint u_YBaseTexture; // Y texture uniform for Y channel
                                        //i.e. image is not RGB but YUV


@property (readonly) GLuint u_BaseTextureRGB; //FOR RGB base image it will be single one to represent an image


@property (readonly) GLuint a_TexturePosition;
@property (readonly) GLuint a_TextureCoordinate;

@property (readonly) NSMutableDictionary *uniformDictionary;
@property (readonly) NSMutableDictionary *attributeDictionary;
@end
