//
//  CameraSession.m
//  RILiveStreaming
//
//  Created by Mostafizur Rahman on 10/16/16.
//  Copyright © 2016 Mostafizur Rahman. All rights reserved.
//

#import "TCCameraSession.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/ImageIO.h>
#define BUFFER_SIZE 60000
#define MAX_FRAME_RATE 29
#define byte unsigned char

@interface TCCameraSession()
{
    AVCaptureSession *captureSession;
    dispatch_queue_t videoBufferQueue;
    dispatch_queue_t audioBufferQueue;
    AVCaptureConnection *videoConnection;
    AVCaptureConnection *audioConnection;
    AVCaptureConnection         *stillImageConnection;
    AVCaptureStillImageOutput   *stillImageOutput;
    AVCaptureVideoDataOutput *videoDataOutput;
    AVCaptureAudioDataOutput *audioDataOutput;
    
    BOOL shouldSetupResolution;
    BOOL shouldStopRendering;
}


@end

@implementation TCCameraSession
@synthesize glk_maskView;

-(void)initSessionWithView:(UIView *)parentView {
  
    shouldSetupResolution = YES;
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [self setCameraInSession:captureSession];
    //[self setAudioDataOutputFromSession:captureSession];
//    [self setPreviewLayerInParentView:parentView fromSession:captureSession];
    [self setVideoDataOutptFromSession:captureSession];
    [self setStillImageOutputInSession:captureSession];
    
}

-(void)setCameraInSession:(AVCaptureSession *)session
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSArray *devices = AVCaptureDevice.devices;
    for(AVCaptureDevice *device in devices) {
        if(device.position == AVCaptureDevicePositionFront) {
            videoDevice = device;
            break;
        }
    }
    AVCaptureDeviceInput *capInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    if (capInput) [session addInput:capInput];
}

-(void)setAudioDataOutputFromSession:(AVCaptureSession *)session
{
    audioBufferQueue = dispatch_queue_create(QUEUE_NAME_AUDIO, DISPATCH_QUEUE_CONCURRENT);
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        [session addInput:audioInput];
    }
    audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];
    [audioDataOutput setSampleBufferDelegate:self queue:audioBufferQueue];
    audioConnection = [audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    session.automaticallyConfiguresApplicationAudioSession = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setPreferredSampleRate:44100 error:nil];
    session.usesApplicationAudioSession = YES;
    
    if([session canAddOutput:audioDataOutput]) {
        [session addOutput:audioDataOutput];
    }
}

-(void)setVideoDataOutptFromSession:(AVCaptureSession *)session
{
    videoBufferQueue = dispatch_queue_create(QUEUE_NAME_VIDEO, DISPATCH_QUEUE_CONCURRENT);
    videoDataOutput =  [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *videoDataSettigns = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    videoDataOutput.videoSettings = videoDataSettigns;
    [videoDataOutput setSampleBufferDelegate:self queue:videoBufferQueue];

    
    if([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    }
    videoConnection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection) {
        videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//        [videoConnection setVideoMirrored:YES];
    }
}

-(void)setStillImageOutputInSession:(AVCaptureSession *)session {
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey]];
   
    if([session canAddOutput:stillImageOutput] ) {
        [session addOutput:stillImageOutput];
    }
    stillImageConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
}

-(void) setPreviewLayerInParentView:(UIView *)parentView fromSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.bounds = parentView.bounds;
    previewLayer.position = parentView.center;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [parentView.layer insertSublayer:previewLayer atIndex:0];
}

-(void)capturePhoto{
    shouldStopRendering = YES;
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if(shouldStopRendering){
             shouldStopRendering = NO;
             [captureSession stopRunning];
             if(imageSampleBuffer != NULL){
                 
                 NSData *imageRawData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                     UIImage *rawImage = [[UIImage alloc] initWithData:imageRawData];
                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [self.glk_maskView onImageCapturedSuccess:rawImage ];
                     });
                 });
             }
         }
     }];
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
      fromConnection:(AVCaptureConnection *)connection{
    if([captureOutput isKindOfClass:[AVCaptureAudioDataOutput class]]){
        NSLog(@"audio channel found");
        //       [glk_maskView cameraSampleBuffer:sampleBuffer];
    }else {
        if(shouldSetupResolution){
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            CGSize resolution = CVImageBufferGetDisplaySize(imageBuffer);
            [glk_maskView generateDefaultVBO:resolution];
            shouldSetupResolution  = NO;
        }
        [glk_maskView setCameraSampleBuffer:sampleBuffer];
    }
    
}


-(void)stopSession {
    if([captureSession isRunning]){
        [captureSession stopRunning];
    }
}

-(void)startSession{
    if(![captureSession isRunning]){
        [captureSession startRunning];
    }
}
@end
