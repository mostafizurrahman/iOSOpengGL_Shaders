//
//  GLKStickerView.m
//  MagicSticker
//
//  Created by Mostafizur Rahman on 11/18/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GLKDetectionView.h"




#define MAINSCRN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAINSCRN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define MAINSCRN_SCALE [UIScreen mainScreen].scale

@interface GLKDetectionView(){
    
    CGRect sourceImageExtent;
    CGRect screenImageExtent;
                                 // initfrom eaglcontext
    CIContext   *drawingContext;  //opengl backed drawing context
    NSMutableArray *amimImageArray;
    
    BOOL shouldStartAnimation;
    
    
    //video data
    CGSize inputVideoSize;
    unsigned char *videoPiexelBuffer;
    long long videoDataLength;
    
    //GL variables
    EAGLContext *openglContext;
    CAEAGLLayer* openglLayer;
    
}
@end
@implementation GLKDetectionView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
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
    openglLayer.opaque = NO;
    openglLayer.drawableProperties =
    [NSDictionary dictionaryWithObjectsAndKeys: kEAGLColorFormatRGBA8,
                                     kEAGLDrawablePropertyColorFormat, nil];
    [self bindDrawable];
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    [openglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:openglLayer];
    if (openglContext != [EAGLContext currentContext])
        [EAGLContext setCurrentContext:openglContext];
    self.enableSetNeedsDisplay = NO;
    //assuming camera feed will be rendered full screen in GLKView
    //if glview size differs from full screen uncomment the below line
    //and delete main screen size
    CGSize size = CGSizeMake(MAINSCRN_WIDTH, MAINSCRN_HEIGHT); // self.bounds.size;
    screenImageExtent = CGRectMake(0, 0, size.width * MAINSCRN_SCALE,
                                    size.height * MAINSCRN_SCALE);
    return YES;
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
-(void)cameraSampleBuffer:(CMSampleBufferRef)sampleBuffer {

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

