//
//  GLKStickerView.h
//  MagicSticker
//
//  Created by Mostafizur Rahman on 11/18/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIDevice.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <CoreImage/CIDetector.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>



@interface GLKDetectionView : GLKView
-(BOOL)setupOpenGLContext;
-(void)setCameraSampleBuffer:(CMSampleBufferRef)sampleBuffer;
-(void)setVideoDelegate:(id)delegate;
-(void)generateDefaultVBO:(const CGSize)cameraResolution;

@property (readwrite) dispatch_queue_t videoOutputQueue;
@property (readwrite) BOOL shouldApplyThreshold;
@property (readwrite) BOOL startVideoCapturing;



@end
