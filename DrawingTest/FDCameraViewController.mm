//
//  FDCameraSessionHandler.m
//  FDFaceMasking
//
//  Copyright © 2016 IPvision Canada Inc. All rights reserved.
//

#import "FDCameraViewController.h"


@interface FDCameraViewController (){
    
    FDCameraSessionHandler *sessionHandler;
}

@end

@implementation FDCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearImage)];
    tapGesture.numberOfTapsRequired = 1;
    self.captureImageView.gestureRecognizers = [NSArray arrayWithObjects:tapGesture, nil];
}

-(void)clearImage {
    self.captureImageView.image = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.maskCollectionView];

    sessionHandler = [[FDCameraSessionHandler alloc] initCameraSessionWith:self.view];
    sessionHandler.glkDrawingView = self.glkDrawingView;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)glkViewController:(GLKViewController *)controller willPause:(BOOL)pause{
    if(pause) {
        [sessionHandler pauseCaptureSession];
        [_captureButton setTitle:@"Capture Video" forState:UIControlStateNormal];
    }
    else {
        [sessionHandler resumeCaptureSessionWith:self.view];
    }
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller{
    [self.glkDrawingView render];
}

-(IBAction)exit:(id)sender{

	[self.navigationController popViewControllerAnimated:YES];

}







@end
