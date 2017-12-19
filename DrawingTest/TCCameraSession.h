//
//  CameraSession.h
//  RILiveStreaming
//
//  Created by Mostafizur Rahman on 10/16/16.
//  Copyright © 2016 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "GLKDetectionView.h"

//#import "LSAVDataConverter.h"

#define QUEUE_NAME_VIDEO "RingID.LiveStreaming.VideoSampleQueue"
#define QUEUE_NAME_AUDIO "RingID.LiveStreaming.AudioSampleQueue"



@interface TCCameraSession : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

-(void)initSessionWithView:(UIView *)parentView;


@property (readwrite, strong) GLKDetectionView *glk_maskView;

-(void)capturePhoto;
-(void)stopSession;
-(void)startSession;

@end
