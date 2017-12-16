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

@property (readwrite) GLuint u_UVBaseTexture;
@property (readwrite) GLuint u_YBaseTexture;


@property (readwrite) GLuint u_BaseTextureRGB;
@property (readwrite) GLuint a_TexturePosition;
@property (readwrite) GLuint a_TextureCoordinate;

@end


@implementation ShaderBaseProgram
@synthesize u_BaseTextureRGB;
@synthesize a_TexturePosition;
@synthesize a_TextureCoordinate;

@synthesize u_YBaseTexture;
@synthesize u_UVBaseTexture;

@synthesize uniformDictionary;
@synthesize attributeDictionary;




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
    uniformDictionary = [[NSMutableDictionary alloc] init];
    attributeDictionary = [[NSMutableDictionary alloc] init];
    
    textureType = t_type;
    
    [self compileProgram:vshaderName fragShader:fshaderName];
    return self;
}

-(void)compileProgram:(NSString *)vshader fragShader:(NSString *)fshader{
    glu_vertShaderID = [self compileShader:vshader withType:GL_VERTEX_SHADER];
    if(glu_fragShaderID == GL_ERR){
        NSLog(@"error in fragmentShader");
        return;
    }
    glu_fragShaderID = [self compileShader:fshader withType:GL_FRAGMENT_SHADER];
    if(glu_fragShaderID == GL_ERR){
        NSLog(@"error in vertexShader");
        return;
    }
    
    [self generateProgram];
    [self setupCommotAttribs];
}

-(void)generateProgram{
    glu_shaderProgram = glCreateProgram();
    glAttachShader(glu_shaderProgram, glu_vertShaderID);
    glAttachShader(glu_shaderProgram, glu_fragShaderID);
    glLinkProgram(glu_shaderProgram);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(glu_shaderProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(glu_shaderProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
    }
}

-(void)setupCommotAttribs {
    //get either Y texture and UV Textures OR get RGB single Texture.
    if(textureType == BaseTextureTypeYUV){
        self.u_YBaseTexture = glGetUniformLocation(glu_shaderProgram, "u_TextureBaseY");
        [uniformDictionary setObject:[NSNumber numberWithInteger:self.u_YBaseTexture] forKey:@"u_TextureBaseY"];
        self.u_UVBaseTexture = glGetUniformLocation(glu_shaderProgram, "u_TextureBaseUV");
        [uniformDictionary setObject:[NSNumber numberWithInteger:self.u_UVBaseTexture] forKey:@"u_TextureBaseUV"];
        
        
    } else if(textureType == BaseTextureTypeRGB){
        self.u_BaseTextureRGB = glGetUniformLocation(glu_shaderProgram, "u_TextureBaseRGB");
        [uniformDictionary setObject:[NSNumber numberWithInteger:self.u_BaseTextureRGB] forKey:@"u_TextureBaseRGB"];
    }
    //Position vec4 and Texture Coordinate vec2, these two parameters are same for both YUV and RGBA texture
    self.a_TexturePosition = glGetAttribLocation(glu_shaderProgram, "a_TexturePosition");
    [attributeDictionary setObject:[NSNumber numberWithInteger:self.a_TexturePosition] forKey:@"a_TexturePosition"];
    self.a_TextureCoordinate = glGetAttribLocation(glu_shaderProgram, "a_TextureCoordinate");
    [attributeDictionary setObject:[NSNumber numberWithInteger:self.a_TextureCoordinate] forKey:@"a_TextureCoordinate"];
}

- (void)useAttribute {
    
}

- (void)useUniform:(NSString *)uniformName {
    
}

-(void)useShaderProgram{
    glUseProgram(glu_shaderProgram);
}

#pragma -mark COMPILER SHADERS FUNCTIONS

- (void)compileShaderProgram:(const GLuint)vertexShader
                  fragShader:(const GLuint)fragmentShader{
    
    glu_shaderProgram = glCreateProgram();
    glAttachShader(glu_shaderProgram, vertexShader);
    glAttachShader(glu_shaderProgram, fragmentShader);
    glLinkProgram(glu_shaderProgram);
    
    //link checkers a.k.a gl error check for shader program
    GLint linkSuccess;
    glGetProgramiv(glu_shaderProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(glu_shaderProgram, sizeof(messages), 0, &messages[0]);
        NSString *errMsg = [NSString stringWithUTF8String:messages];
        programErrorInfo = [NSDictionary dictionaryWithObjectsAndKeys:errMsg,@"ErorrMsg", nil];
        return;
    }
}

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
