//
//  CameraGLView.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/9/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "CameraGLView.h"
#import "TextureLoader.h"
#import "FDShaders.h"



@interface CameraGLView(){
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    BOOL mRender;
    
    BOOL captureImage;
    BOOL captureVideo;
    
    
    GLKMatrix4 mvpMatrix;
    
    GLubyte* videoFrameBuffer;
    GLuint vertexShaderCommon;
    GLuint fragmentShaderAnimation;
    
    GLint defaultFrameBuffer;
    GLuint frameBuffer[1];
    TextureLoader* offscreenTextureLoader;
    CGRect viewport;
    CGSize cameraResolution;
    GLubyte offscreenToOnscreenIndices[6];
    GLVertexData_t offscreenToOnscreenVertices[4];
    GLuint offscreenToOnscreenTextureCoordLoc;
    GLuint offscreenToOnscreenVertexLoc;
    GLuint offscreenToOnscreenTexture;
    GLuint offscreenToOnscreenVertexBufferID;
    GLuint offscreenToOnscreenIndexBufferID;
    GLuint offscreenToOnscreenVertexShader;
    GLuint offscreenToOnscreenFragmentShader;
    GLuint offscreenToOnscreenShaderProgram;
}


@end

@implementation CameraGLView
@synthesize cameraRender;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setupContext];
    [self setupLayer];
    [self loadShaders];
    [self setupOffscreenRendering];
    cameraRender = [[FDCameraRenderer alloc] init];
    mRender = YES;
    return self;
}
+ (Class)layerClass {
    return [CAEAGLLayer class];
}
//
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = NO;
    _eaglLayer.drawableProperties =
    [NSDictionary dictionaryWithObjectsAndKeys: kEAGLColorFormatRGBA8,
     kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView* view = (GLKView*) self;
    view.context = _context;
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)setupOffscreenRendering {
    CGSize nativeSize = [[UIScreen mainScreen] nativeBounds].size;
    offscreenTextureLoader = [[TextureLoader alloc] init];
    cameraResolution = CGSizeMake(1072, 1920);
    [offscreenTextureLoader generateTextureOfSize:cameraResolution];
    viewport = CGRectMake(0, 0, nativeSize.width, nativeSize.height);
    
    GLVertexData_t obj1, obj2, obj3, obj4;
    obj1.position[0] = -1.f;
    obj1.position[1] = 1.f;
    obj1.position[2] = 0.f;
    obj1.uv[0] = 0.f;
    obj1.uv[1] = 0.f;
    
    obj2.position[0] = -1.f;
    obj2.position[1] = -1.f;
    obj2.position[2] = 0.f;
    obj2.uv[0] = 0.f;
    obj2.uv[1] = 1.f;
    
    obj3.position[0] = 1.f;
    obj3.position[1] = -1.f;
    obj3.position[2] = 0.f;
    obj3.uv[0] = 1.f;
    obj3.uv[1] = 1.f;
    
    obj4.position[0] = 1.f;
    obj4.position[1] = 1.f;
    obj4.position[2] = 0.f;
    obj4.uv[0] = 1.f;
    obj4.uv[1] = 0.f;
    
    offscreenToOnscreenVertices[0] = obj1;
    offscreenToOnscreenVertices[1] = obj2;
    offscreenToOnscreenVertices[2] = obj3;
    offscreenToOnscreenVertices[3] = obj4;
    
    offscreenToOnscreenIndices[0] = 0;
    offscreenToOnscreenIndices[1] = 1;
    offscreenToOnscreenIndices[2] = 2;
    offscreenToOnscreenIndices[3] = 0;
    offscreenToOnscreenIndices[4] = 2;
    offscreenToOnscreenIndices[5] = 3;
    
    glGenFramebuffers(1, frameBuffer);
    glGenBuffers(1, &offscreenToOnscreenVertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, offscreenToOnscreenVertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(offscreenToOnscreenVertices),
                 offscreenToOnscreenVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &offscreenToOnscreenIndexBufferID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, offscreenToOnscreenIndexBufferID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(offscreenToOnscreenIndices),
                 offscreenToOnscreenIndices, GL_STATIC_DRAW);
    
    
}


-(void)loadShaders {
    
    const GLchar* vertTOffscreenToOnscreen = [VERTEX_SHADER_OFFSCREEN_TO_ONSCREEN UTF8String];
    const GLchar* fragTOffscreenToOnscreen = [FRAGMENT_SHADER_OFFSCREEN_TO_ONSCREEN UTF8String];
    
    const GLchar* verTCommon = [VERTEX_SHADER_CAMERA_PREVIEW UTF8String];
    
    vertexShaderCommon = glCreateShaderProgramvEXT(GL_VERTEX_SHADER, 1, &verTCommon);
    
    offscreenToOnscreenVertexShader = glCreateShaderProgramvEXT(GL_VERTEX_SHADER, 1, &vertTOffscreenToOnscreen);
    offscreenToOnscreenFragmentShader = glCreateShaderProgramvEXT(GL_FRAGMENT_SHADER, 1, &fragTOffscreenToOnscreen);
    
    offscreenToOnscreenVertexLoc = glGetAttribLocation(offscreenToOnscreenVertexShader, "a_position");
    offscreenToOnscreenTextureCoordLoc = glGetAttribLocation(offscreenToOnscreenVertexShader, "a_texCoord");
    offscreenToOnscreenTexture = glGetUniformLocation(offscreenToOnscreenFragmentShader, "u_texture");
    
    glGenProgramPipelinesEXT(1, &offscreenToOnscreenShaderProgram);
    glBindProgramPipelineEXT(offscreenToOnscreenShaderProgram);
    glUseProgramStagesEXT(offscreenToOnscreenShaderProgram, GL_VERTEX_SHADER_BIT_EXT, offscreenToOnscreenVertexShader);
    glUseProgramStagesEXT(offscreenToOnscreenShaderProgram, GL_FRAGMENT_SHADER_BIT_EXT, offscreenToOnscreenFragmentShader);
}

- (void) setCameraResolution:(CGSize)resolution KeepAspectRatio:(BOOL)shouldKeep {
    cameraResolution = resolution;
    
    mvpMatrix = GLKMatrix4MakeOrtho(0, cameraResolution.width, cameraResolution.height, 0, 0, 1);
    
    
    
    CGSize nativeSize = [[UIScreen mainScreen] nativeBounds].size;
    
    const float viewportH = !shouldKeep ? nativeSize.height : (resolution.height /
                                                               resolution.width) * nativeSize.width;
    const float offset = (nativeSize.height - viewportH) / 2.f;
    
    viewport = CGRectMake(0, offset, nativeSize.width, viewportH);
    
    [cameraRender setCameraResolution:cameraResolution];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [offscreenTextureLoader deleteTexture];
        [offscreenTextureLoader generateTextureOfSize:cameraResolution];
        glViewport(0, offset, nativeSize.width, viewportH);
    });
}

- (void)render{
    
    if (mRender) {
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFrameBuffer);
        
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer[0]);
        [offscreenTextureLoader renderFramebufferToTexture:frameBuffer[0]];
        glViewport(0, 0, cameraResolution.width, cameraResolution.height);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        [cameraRender render];//implement later
        

        glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
        glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width, viewport.size.height);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        glBindProgramPipelineEXT(offscreenToOnscreenShaderProgram);
        glBindBuffer(GL_ARRAY_BUFFER, offscreenToOnscreenVertexBufferID);
        
        glEnableVertexAttribArray(offscreenToOnscreenVertexLoc);
        glVertexAttribPointer(offscreenToOnscreenVertexLoc, 3, GL_FLOAT, GL_FALSE, sizeof(GLVertexData_t),
                              (GLvoid*) offsetof(GLVertexData_t, position));
        glEnableVertexAttribArray(offscreenToOnscreenTextureCoordLoc);
        glVertexAttribPointer(offscreenToOnscreenTextureCoordLoc, 2, GL_FLOAT, GL_FALSE, sizeof(GLVertexData_t),
                              (GLvoid*) offsetof(GLVertexData_t, uv));
        [offscreenTextureLoader activeTexture:5];
        glProgramUniform1iEXT(offscreenToOnscreenFragmentShader, offscreenToOnscreenTexture, 5);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, offscreenToOnscreenIndexBufferID);
        glDrawElements(GL_TRIANGLES, sizeof(offscreenToOnscreenIndices)/sizeof(offscreenToOnscreenIndices[0]),
                       GL_UNSIGNED_BYTE, 0);
        glDisableVertexAttribArray(offscreenToOnscreenVertexLoc);
        glDisableVertexAttribArray(offscreenToOnscreenTextureCoordLoc);
        
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    }
}

@end
