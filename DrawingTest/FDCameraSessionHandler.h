//
//  FDCameraSessionHandler.h
//  FDFaceMasking
//
//  Copyright © 2016 IPvision Canada Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraGLView.h"



/**
 
 @class FDCameraSessionHandler
 
 @brief This class used to setup and manage camera session
 
 @superclass Superclass:NSObject,AVCaptureVideoDataOutputSampleBufferDelegate(protocol)
 
 */
@interface FDCameraSessionHandler : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

/// instance of AVCaptureSession created in this class
@property (readonly) AVCaptureSession *cameraCaptureSession;
@property (readwrite) CameraGLView *glkDrawingView;
/**
 FDFaceMasking framework instance
 */


/**
 @brief Initialize instance of this class and camera with required options and preview in the view given
 
 @param parentView preview will be done in this view
 @return instance of this class
 */
-(id)initCameraSessionWith:(UIView *)parentView;

/**
 @brief start the CaptureSession
 */
-(void)startCaptureSession;
/**
 @brief stop the CatureSession
 */
-(void)stopCaptureSession;
/**
 @brief resume CaptureSession, used when the view returns from background to foreground
 
 @param parentView where the camera preview will be shown
 */
-(void)resumeCaptureSessionWith:(UIView *)parentView;
/**
 @brief pause the CaptureSession, used when the view(which is showing the camera preview) goes to background
 */
-(void)pauseCaptureSession;

-(void)initializeFDFaceMasking;

-(void)destroyFDFaceMasking;

@end
