//
//  ShaderBaseProgram.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/13/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "ShaderBaseProgram.h"

@interface ShaderBaseProgram(){
    GLuint glu_shaderProgram;
    GLuint glu_vertShaderID;
    GLuint glu_fragShaderID;
    NSDictionary *programErrorInfo;
    BaseTextureType textureType;
}
@end


@implementation ShaderBaseProgram
@synthesize u_BaseTexture;
@synthesize a_TexturePosition;
@synthesize a_TextureCoordinate;

@synthesize u_YBaseTexture;
@synthesize u_UVBaseTexture;

- (NSString *)checkGLError {
    return [programErrorInfo objectForKey:@"ErorrMsg"];
}

- (GLuint)getProgramHandler {
    return glu_shaderProgram;
}

- (instancetype)initWithVShader:(NSString *)vshaderName
             withFragmentShader:(NSString *)fshaderName
                    textureType:(BaseTextureType)t_type{
    self = [super init];
    textureType = t_type;
    [self compileProgram:vshaderName fragShader:fshaderName];
    return self;
}

-(void)compileProgram:(NSString *)vshader fragShader:(NSString *)fshader{
    glu_vertShaderID = [self compileShader:vshader withType:GL_VERTEX_SHADER];
    if(glu_fragShaderID == GL_ERR){
        return;
    }
    glu_fragShaderID = [self compileShader:fshader withType:GL_FRAGMENT_SHADER];
    if(glu_fragShaderID == GL_ERR){
        return;
    }
    [self setupCommotAttribs];
}

-(void)setupCommotAttribs {
    if(textureType == BaseTextureTypeYUV){
        
    } else if(textureType == BaseTextureTypeRGB){
        
    }
        
}

- (void)useAttribute:(NSString *)attributeName {
    
}

- (void)useUniform:(NSString *)uniformName {
    
}














#pragma -mark COMPILER SHADERS FUNCTIONS


- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    //get the shader file contents from the MainBundle
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:PRG_TYPE];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    //check shader base file error
    if (!shaderString) {
        NSString *errMsg = [NSString stringWithFormat:@"Error loading shader: %@",
                            error.localizedDescription];
        programErrorInfo = [NSDictionary dictionaryWithObjectsAndKeys:errMsg,@"ErorrMsg", nil];
        return -1;
    }
    //create shader program
    GLuint shaderHandler = glCreateShader(shaderType);
    
    //create program string bytes
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandler, 1, &shaderStringUTF8, &shaderStringLength);
    //compile source
    glCompileShader(shaderHandler);
    //check shader error
    GLint compileSuccess;
    glGetShaderiv(shaderHandler, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandler, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        programErrorInfo = [NSDictionary dictionaryWithObjectsAndKeys:messageString,@"ErorrMsg", nil];
        return -1;
    }
    return shaderHandler;
}

@end
