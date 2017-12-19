//
//  GLKStickerView.m
//  MagicSticker
//
//  Created by Mostafizur Rahman on 11/18/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GLKDetectionView.h"
#import "FDShaderProgram.h"
#import "GSCameraRenderer.h"


@interface GLKDetectionView(){
    
    
    
    
    CGRect sourceImageExtent;
    CGRect screenImageExtent;
                                 // initfrom eaglcontext
    CIContext   *drawingContext;  //opengl backed drawing context
    NSMutableArray *amimImageArray;
    
    BOOL shouldStartAnimation;
    
    dispatch_queue_t videoRendererQueue;
    
    
    FDShaderProgram *_shaderProgram;
    
    GSCameraRenderer *cameraRenderer;
    
    //video data
    CGSize inputVideoSize;
    unsigned char *videoPiexelBuffer;
    unsigned long videoDataLength;
    
    //GL variables
    EAGLContext *openglContext;
    CAEAGLLayer* openglLayer;
    
    //VBOs
    
    GLint vbo_defaultFrameBuffer;
    GLuint vbo_drawingFrameBuffer;
    GLuint vbo_defaultDepthBuffer;
    GLuint vbo_dfOffscreenTexture;
    
    
    GLuint vbo_vertexBufferID;
    GLuint vbo_indexBufferID;
    
    
    GLuint texture;
    
}
@end
@implementation GLKDetectionView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        videoRendererQueue = dispatch_queue_create("com.facedetection.video",
                                                   DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(videoRendererQueue,
                                  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
        
    }
    return self;
}
+(Class)layerClass{
    return [CAEAGLLayer class];
}

-(BOOL)shouldSetupContext{
    return openglContext == nil;
}

-(BOOL)setupOpenGLContext{
    openglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    drawingContext = [CIContext contextWithEAGLContext:openglContext];
    self.context = openglContext;
    openglLayer = (CAEAGLLayer*) self.layer;
    if (openglContext != [EAGLContext currentContext])
        [EAGLContext setCurrentContext:openglContext];
    
    openglLayer.opaque = NO;
    openglLayer.drawableProperties =
    [NSDictionary dictionaryWithObjectsAndKeys: kEAGLColorFormatRGBA8,
                                     kEAGLDrawablePropertyColorFormat, nil];
    
    [self initializeDefaultDrawing];
    self.enableSetNeedsDisplay = NO;
    //assuming camera feed will be rendered full screen in GLKView
    //if glview size differs from full screen uncomment the below line
    //and delete main screen size
    CGSize size = CGSizeMake(MAINSCRN_WIDTH, MAINSCRN_HEIGHT); // self.bounds.size;
    screenImageExtent = CGRectMake(0, 0, size.width * MAINSCRN_SCALE,
                                    size.height * MAINSCRN_SCALE);
    
    
    
    return YES;
}

-(void)initializeDefaultDrawing{
    glGenBuffers(1, &vbo_vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(DefaultVertices), DefaultVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &vbo_indexBufferID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo_indexBufferID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(DefaultIndices), DefaultIndices, GL_STATIC_DRAW);
    
    
    _shaderProgram = [[FDShaderProgram alloc] initWithVShader:@"FaceMaskVShader"
                                           withFragmentShader:@"FaceMaskFShader"
                                                  textureType:BaseTextureTypeRGB];
    cameraRenderer = [[GSCameraRenderer alloc] initWithContext:openglContext opengProgram:_shaderProgram];
    
    [self generateDefaultVBO:CGSizeMake(1080, 1822)];
    
}

-(void)setDefaultContext{
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)generateDefaultVBO:(const CGSize)cameraResolution{
    
   
    [self bindDrawable];
     glGetIntegerv(GL_FRAMEBUFFER_BINDING, &vbo_defaultFrameBuffer);
    videoDataLength = cameraResolution.width * cameraResolution.height * 4;
    videoPiexelBuffer = (unsigned char *)malloc(videoDataLength * sizeof(unsigned char *));
//    [cameraRenderer generateTexture:cameraResolution];
    sourceImageExtent = CGRectMake(0, 0, cameraResolution.width,
                                   cameraResolution.height);
    
    
    
    glGenFramebuffers(1, &vbo_drawingFrameBuffer);
    glGenTextures(1, &vbo_dfOffscreenTexture);
    glGenRenderbuffers(1, &vbo_defaultDepthBuffer);
    
    glBindTexture(GL_TEXTURE_2D, vbo_dfOffscreenTexture);
    [cameraRenderer setTextParameters];
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, cameraResolution.width,
                 cameraResolution.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    
    glBindRenderbuffer(GL_RENDERBUFFER, vbo_defaultDepthBuffer);

    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16,
                          cameraResolution.width, cameraResolution.height);
    [openglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:openglLayer];
    
    glBindFramebuffer(GL_FRAMEBUFFER, vbo_drawingFrameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,
                           vbo_dfOffscreenTexture, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT,
                              GL_RENDERBUFFER, vbo_defaultDepthBuffer);
    
    
    
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle ] pathForResource:@"image" ofType:@"png"]];
    texture = [cameraRenderer setupTexture:image];
    [self renderCamera];
    
}

-(void)renderCamera {
//    [self bindDrawable];
   
    
    
    // 2. RENDER TO OFFSCREEN RENDER TARGET
    glBindFramebuffer(GL_FRAMEBUFFER, vbo_drawingFrameBuffer);
    GLuint programId = [_shaderProgram getProgramHandler];
    
    glUseProgram(programId);
    glViewport(0, 0, sourceImageExtent.size.width,
               sourceImageExtent.size.height);
    [self setDefaultContext];
    /// DRAW THE SCENE ///
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo_vertexBufferID);
    glEnableVertexAttribArray(_shaderProgram.a_TexturePosition);
    glVertexAttribPointer(_shaderProgram.a_TexturePosition, 3, GL_FLOAT, GL_FALSE,
                          sizeof(VertexData_t), (GLvoid*) offsetof(VertexData_t, Position));
    glEnableVertexAttribArray(_shaderProgram.a_TextureCoordinate);
    glVertexAttribPointer(_shaderProgram.a_TextureCoordinate, 2, GL_FLOAT, GL_FALSE,
                          sizeof(VertexData_t), (GLvoid*) offsetof(VertexData_t, TexCoord));
    
    glActiveTexture(GL_TEXTURE0+1);
    
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(_shaderProgram.u_BaseTextureRGB, 1);
//    glProgramUniform1iEXT(programId, _shaderProgram.u_BaseTextureRGB, texture);
//    [cameraRenderer renderCameraBuffer:videoPiexelBuffer];
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo_indexBufferID);
    glDrawElements(GL_TRIANGLES, sizeof(DefaultIndices)/sizeof(DefaultIndices[0]),
                   GL_UNSIGNED_BYTE, 0);
    [self getImage];
    // 3. RESTORE DEFAULT FRAME BUFFER
    glBindFramebuffer(GL_FRAMEBUFFER, vbo_defaultFrameBuffer);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    // 4. RENDER FULLSCREEN QUAD
    glViewport(0, 0, screenImageExtent.size.width,
               screenImageExtent.size.height);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
}


-(UIImage *)getImage{
    CGSize imageSize = sourceImageExtent.size;
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
    CGImageRef imageRef = CGImageCreate(imageSize.width, imageSize.height, bitsPerComponent,
                                        bitsPerPixel, bytesPerRow, colorSpaceRef,
                                        bitmapInfo, provider, NULL, NO, renderingIntent);
    UIGraphicsBeginImageContext(imageSize);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), imageRef);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    free(buffer);
    return image;
}


-(void)dealloc{
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
    [self deleteDrawable];
    if([[EAGLContext currentContext] isEqual:openglContext]){
        [EAGLContext setCurrentContext: nil];
        openglContext = nil;
        [drawingContext clearCaches];
    }
}

//OpenGLES backed CIContext for faster drawing.
-(CIContext *)getDrawingContext{
    return drawingContext;
}

//fired delegate from TCCameraSession::SampleBufferOutputDelegateMethod
-(void)setCameraSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    const unsigned char *pixelBaseAdd = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    memcpy(videoPiexelBuffer, pixelBaseAdd, videoDataLength);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    dispatch_async(videoRendererQueue, ^{
        [self renderCamera];
    });
    
}


-(CGFloat) degreesToRadians:(CGFloat) value{
    return M_PI * value / 180.0;
}

-(void)setVideoDelegate:(id)delegate{
    //set up video capturing delegate here,
    //The delegate will reside in avassetwriter
    //subclass, after capturing video delegate
    //will be used to notify the receiver.
}

@end

