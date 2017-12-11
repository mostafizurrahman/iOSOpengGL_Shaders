//
//  FDCameraSessionHandler.h
//  FDFaceMasking
//
//  Copyright © 2016 IPvision Canada Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "FDCameraSessionHandler.h"



/**
 @class FDCameraViewController
 
 @brief ViewController responsible for showing the camera preview
 
 @discussion GLKViewController is used for the delegate methods available- when to render the glkview and when the glkview rendering is paused and resumed, these methods are used to maintan the rendering of the mask
 
 @superclass Superclass:GLKViewController, Protocol:GLKViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource
 */
@interface FDCameraViewController : GLKViewController<GLKViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;

/// button for exiting the preview
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet CameraGLView *glkDrawingView;

@property(weak,nonatomic) IBOutlet UIButton *activeButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
/// collectionview instance which is used o show the masks available works as a selector of that mask to render that mask
@property (weak, nonatomic) IBOutlet UICollectionView *maskCollectionView;

@end

