//
//  OpenGLView.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 10/25/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "OpenGLView.h"
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#define TEX_COORD_MAX   4




typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

@implementation OpenGLView

- (void)render {
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0, 0.0, 0.0, 0.0);
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    [textureLoader renderFramebufferToTexture:framebuffer];
    glViewport(0, 0, 1080, 1822);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(_positionSlot);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, Position));
    glEnableVertexAttribArray(_colorSlot);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, Color));
    glEnableVertexAttribArray(_texCoordSlot);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, TexCoord));
    [textureLoader activeTexture:1];
    
//    [textureLoader uploadData:textureData formMat:GL_RGBA];
    glProgramUniform1iEXT(programHandle, _floorTexture, 1);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                   GL_UNSIGNED_BYTE, 0);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    [self getImage];
    
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
    glViewport(0, 0, 640, 1136);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    
    glEnableVertexAttribArray(offscreenToOnscreenVertexLoc);
    glVertexAttribPointer(offscreenToOnscreenVertexLoc, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, Position));
    glEnableVertexAttribArray(offscreenToOnscreenTextureCoordLoc);
    glVertexAttribPointer(offscreenToOnscreenTextureCoordLoc, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, TexCoord));
    [textureLoader activeTexture:3];
    glProgramUniform1iEXT(offscreenToOnscreenShaderProgram, offscreenToOnscreenTexture, 3);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);
    [self getImage];*/
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    
}

-(UIImage *)getGLImage{
    [self setupTexture:@"img.png"];
    [self render];
    return nil;
}

-(UIImage *)getImage{
    CGSize imageSize = CGSizeMake(1080, 1822);
    NSUInteger length = imageSize.width * imageSize.height * 4;
    GLubyte * buffer = (GLubyte *)malloc(length * sizeof(GLubyte));
    if(buffer == NULL)
        return nil;
    glReadPixels(0, 0, imageSize.width, imageSize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, length, NULL);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * imageSize.width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageSize.width, imageSize.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIGraphicsBeginImageContext(imageSize);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), imageRef);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    free(buffer);
    return image;
}

- (void)setupTexture:(NSString *)fileName {
    
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    textureData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(textureData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    textureLoader = [[TextureLoader alloc] init];
    offscreenTextureLoader = [[TextureLoader alloc] init];
    CGSize cameraResolution = CGSizeMake(1080, 1822);
    [offscreenTextureLoader generateTextureOfSize:cameraResolution];
    [textureLoader generateTextureOfSize:CGSizeMake(width, height)];
}


const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1.5}, {1, 1}},
    {{1, 1, 0}, {0, 1, 0, 1.4}, {1, 0}},
    {{-1, 1, 0}, {0, 0, 1, 1.3}, {0, 0}},
    {{-1, -1, 0}, {0, 0, 0, 1.2}, {0, 1}},
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};


const Vertex Vertices2[] = {
    {{1, -1, 0}, {1, 0, 0, 1.5}, {1, 1}},
    {{1, 1, 0}, {0, 1, 0, 1.4}, {1, 0}},
    {{-1, 1, 0}, {0, 0, 1, 1.3}, {0, 0}},
    {{-1, -1, 0}, {0, 0, 0, 1.2}, {0, 1}},
};

const GLubyte Indices2[] = {
    0, 1, 2,
    2, 3, 0
};

- (void)setupVBOs {
    
  
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShadersOffScreenToOnScreen];
        [self compileShaders];
        [self setupVBOs];
    }
    return self;
}
// Replace dealloc method with this
- (void)dealloc {
    _context = nil;
}
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = NO;
}


- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    cicontext = [CIContext contextWithEAGLContext:_context];
    //    _eaglLayer.backgroundColor = [[UIColor clearColor] CGColor];
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}
//
- (void)setupFrameBuffer {
    glGenFramebuffers(1, &framebuffer);
    
}

















- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}


- (void)compileShadersOffScreenToOnScreen {
    
    GLuint vertexShader = [self compileShader:@"OSVShader"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"OSFShader"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    offscreenToOnscreenShaderProgram = glCreateProgram();
    glAttachShader(offscreenToOnscreenShaderProgram, vertexShader);
    glAttachShader(offscreenToOnscreenShaderProgram, fragmentShader);
    glLinkProgram(offscreenToOnscreenShaderProgram);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(offscreenToOnscreenShaderProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    
    offscreenToOnscreenVertexLoc = glGetAttribLocation(offscreenToOnscreenShaderProgram, "a_position");
    offscreenToOnscreenTextureCoordLoc = glGetAttribLocation(offscreenToOnscreenShaderProgram, "a_texCoord");
    offscreenToOnscreenTexture = glGetUniformLocation(offscreenToOnscreenShaderProgram, "u_texture");
    NSLog(@"done");
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
    _blur_h = glGetUniformLocation(programHandle, "texelHeightOffset");
    _blur_v = glGetUniformLocation(programHandle, "texelWidthOffset");
    _textureFloorUniform = glGetUniformLocation(programHandle, "TextureFloor");
    
    
    blur_radius = glGetUniformLocation(programHandle, "blur_radius");
    direction = glGetUniformLocation(programHandle, "direction");
    resolution = glGetUniformLocation(programHandle, "resolution");
    
    
    // 5
    _textureFloorUniform = glGetUniformLocation(programHandle, "TextureFloor");
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, _brushTexture);
//    glUniform1i(_textureUniform, 0);
    
//    _textureFloorUniform = glGetUniformLocation(programHandle, "TextureFloor");
//    glActiveTexture(GL_TEXTURE0 + 1);
//    glBindTexture(GL_TEXTURE_2D, _floorTexture);
//    glUniform1i(_textureFloorUniform, 1);
    
//    _textureTopUniform = glGetUniformLocation(programHandle, "TextureTop");
//    glActiveTexture(GL_TEXTURE0 + 2);
//    glBindTexture(GL_TEXTURE_2D, _bwTexture);
//    glUniform1i(_textureTopUniform, 2);
    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_texCoordSlot);
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
}

@end
