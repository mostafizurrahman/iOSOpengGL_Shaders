//
//  DrawingView.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 10/24/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "DrawingView.h"



inline CGPoint scalePoint(CGPoint point, CGSize previousSize, CGSize currentSize){
    return CGPointMake(currentSize.width * point.x / previousSize.width, currentSize.height * point.y / previousSize.height);
}

inline CGPoint fromUItoQuartz(CGPoint point, CGSize frameSize){
    point.y = frameSize.height - point.y;
    return point;
}


@interface DrawingView(){
    UIImage *drawingImage;
    UIBezierPath *drawingPath;
    CGContextRef		_imageContext;
}

@end

@implementation DrawingView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self initializeContext];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImage:)];
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
   
    
}

-(void)resetImage:(UITapGestureRecognizer *)tag_g{
    [self initializeContext];
}

-(void)initializeContext{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
    drawingImage = [[UIImage alloc] initWithContentsOfFile:path];
    [super setImage:drawingImage];
    if (NULL != _imageContext) {
        CGContextRelease(_imageContext);
        _imageContext = NULL;
    }
    
    const CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
    _imageContext = CGBitmapContextCreate(0, size.width, size.height, 8, size.width * 4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(_imageContext, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);
    CGContextSetShouldAntialias(_imageContext, YES);
    CGContextSetBlendMode(_imageContext, kCGBlendModeClear);
    CGContextSetLineJoin(_imageContext, kCGLineJoinRound);
    CGContextSetLineCap(_imageContext, kCGLineCapRound);
    CGContextSetLineWidth(_imageContext, 22);
}


-(CGPoint)getConvertedPoint:(UITouch *)touch{
    CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint = fromUItoQuartz(touchPoint, self.bounds.size);
    touchPoint = scalePoint(touchPoint, self.bounds.size, size);
    return touchPoint;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    drawingPath = [UIBezierPath bezierPath];
    drawingPath.lineJoinStyle =  kCGLineJoinMiter;
    const CGPoint c_point = [self getConvertedPoint:[[touches allObjects] firstObject]];
    [drawingPath moveToPoint:c_point];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    const CGPoint c_point = [self getConvertedPoint:[[touches allObjects] firstObject]];
    [drawingPath addLineToPoint:c_point];
    
    
    [self performDrawing];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(_imageContext);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    [super setImage:image];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    [super touchesEnded:touches withEvent:event];
}

#pragma -mark DRAWING_PERFORMING

-(void)performDrawing{
    
//    CGContextRef context = _imageContext;
//    CGContextSaveGState(context);
//    CGRect boundingRect = CGContextGetClipBoundingBox(context);
//    CGContextAddRect(context, boundingRect);
//    CGContextAddPath(context, [drawingPath CGPath]);
//    CGContextEOClip(context);
//    
//    [[UIColor blackColor] setFill];
//    CGContextAddPath(context, [drawingPath CGPath]);
//    CGContextSetShadowWithColor(context, CGSizeMake(1, 1), 1.0, [UIColor blueColor].CGColor);
//    CGContextSetBlendMode (context, kCGBlendModeNormal);
//    CGContextFillPath(context);
//    
//    CGContextAddPath(context, [drawingPath CGPath]);
//    CGContextSetShadowWithColor(context, CGSizeMake(-1, -1), 1.0, [UIColor clearColor].CGColor);
//    CGContextSetBlendMode (context, kCGBlendModeNormal);
//    CGContextFillPath(context);
    
//    CGContextRestoreGState(context);
    
    CGContextAddPath(_imageContext, [drawingPath CGPath]);
    CGContextStrokePath(_imageContext);
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
}

@end
