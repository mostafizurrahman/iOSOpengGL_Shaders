//
//  FDCameraSessionHandler.m
//  FDFaceMasking
//
//  Copyright © 2016 IPvision Canada Inc. All rights reserved.
//

#import "FDCameraSessionHandler.h"

#import <AssetsLibrary/ALAssetsLibrary.h>


@interface FDCameraSessionHandler(){
    AVCaptureConnection *videoConnection;
    dispatch_queue_t videoBufferQueue;
    BOOL shuldUpdateCamRes;
}

@end

@implementation FDCameraSessionHandler

@synthesize glkDrawingView;

-(id)initCameraSessionWith:(UIView *)parentView{
	self = [super init];
	
    shuldUpdateCamRes = YES;
    
    
	[self configureCaptureSessionWith:parentView];
//	[faceMasking changeFilter:GRAYSCALE BlendImagePath:nil];
    [self startCaptureSession];
	return self;
}

-(void)initializeFDFaceMasking {
	
//    [faceMasking start];
}

-(void)destroyFDFaceMasking{
//    [faceMasking cleanup];
}


#pragma -mark Configure Camera Session
-(void)configureCaptureSessionWith:(UIView *)parentView{
    _cameraCaptureSession = [[AVCaptureSession alloc] init];
    
#pragma -prerequisit MUST CHANGE
    //if session preset is changed then change BUFFER_HEIGHT in FDGLobalDefines.h value accordingly
    [_cameraCaptureSession setSessionPreset:AVCaptureSessionPresetHigh];
//    [faceMasking setCameraResolution:resolution KeepAspectRatio:YES];
    [self setCameraInSession:_cameraCaptureSession];
    [self setVideoDataOutptFromSession:_cameraCaptureSession];
    [self resumeCaptureSessionWith:parentView];
    [_cameraCaptureSession startRunning];
}

-(void)setCameraInSession:(AVCaptureSession *)session {
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSArray *devices = AVCaptureDevice.devices;
    for(AVCaptureDevice *device in devices) {
        
        if(device.position == AVCaptureDevicePositionBack) {
            
            videoDevice = device;
            break;
        }
    }
    AVCaptureDeviceInput *capInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    if (capInput) [session addInput:capInput];
}

/**
 @brief setup CaptureVideoDataOutput and add in the capturesession
 
 @discussion pixel format yuv is used for faster processing and different queue is used to maintain the video preview. Video Orientation is set in portrait mode as face masking used mostly in portrait mode
 
 @param session this is the CaptureSession in which the CaptureVideoDataOutput will be added
 */
-(void)setVideoDataOutptFromSession:(AVCaptureSession *)session
{
    videoBufferQueue = dispatch_queue_create("com.image_mony", DISPATCH_QUEUE_SERIAL);
    AVCaptureVideoDataOutput *videoDataOutput =  [[AVCaptureVideoDataOutput alloc] init];
    [videoDataOutput setSampleBufferDelegate:self queue:videoBufferQueue];
  
    NSDictionary *videoDataSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    videoDataOutput.videoSettings = videoDataSettings;
    
    if([session canAddOutput:videoDataOutput]) {
        
        [session addOutput:videoDataOutput];
    }
    videoConnection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection) {
        
        videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
}


#pragma -mark detection queue




#pragma -mark Camera Sample Buffer Output Delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
      fromConnection:(AVCaptureConnection *)connection{

//    if(shuldUpdateCamRes){
//        shuldUpdateCamRes = NO;
//        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        size_t w = 1072;
//        size_t h = CVPixelBufferGetHeight(imageBuffer);
//        [glkDrawingView setCameraResolution:CGSizeMake(w, h) KeepAspectRatio:NO];
//        [glkDrawingView.cameraRender setCameraResolution:CGSizeMake(w, h)];
//    } else
    [glkDrawingView.cameraRender updateSampleBuffer:sampleBuffer];
    
//
}

#pragma -mark Handle Preview Layer for Application States
-(void)startCaptureSession{
    
    [_cameraCaptureSession startRunning];
}

-(void)stopCaptureSession{
    
    [_cameraCaptureSession stopRunning];
}

-(void)resumeCaptureSessionWith:(UIView *)parentView{

//    [faceMasking initializeRendering];
    [self startCaptureSession];
}

-(void)pauseCaptureSession{
    
    [self stopCaptureSession];
//    [faceMasking clearRendering];
}


//- (void)videoRecorded:(NSURL *)videoUrl {
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//    [assetLibrary writeVideoAtPathToSavedPhotosAlbum:videoUrl
//                                     completionBlock:
//     ^(NSURL *assetURL, NSError *error) {
//
//         dispatch_async(dispatch_get_main_queue(), ^{
//
//
//             NSString *title;
//             NSString *message;
//
//             if (error != nil) {
//
//                 title = @"Failed to save video";
//                 message = [error localizedDescription];
//             }
//             else {
//                 title = @"Saved!";
//                 message = nil;
//             }
//             NSError *err = nil;
//             [[NSFileManager defaultManager] removeItemAtURL:videoUrl error:&err];
//             if(err) {
//                 title = [NSString stringWithFormat:@"%@ and Could not Deleted", title];
//             }
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                             message:message
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"OK"
//                                                   otherButtonTitles:nil];
//             [alert show];
//
//         });
//     }];
//}

- (void)videoCanceled {
    NSLog(@"Video Canceled");
}

- (void)audioFinished {
//    [faceMasking finishVideoCapture];
}

-(void)dealloc {
//    videodatao
}
@end
