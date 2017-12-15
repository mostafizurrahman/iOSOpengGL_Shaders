//
//  MSCameraViewController.m
//  FaceDetection
//
//  Created by mostafizur on 5/3/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.


#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "TCCameraSession.h"
#import "GLKDetectionView.h"

@interface MSCameraViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet GLKDetectionView *glk_maskView;


@property (weak, nonatomic) IBOutlet UIImageView *videoView;

@property (weak, nonatomic) IBOutlet UIView *collectionViewController;

@end
