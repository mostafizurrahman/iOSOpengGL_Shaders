//
//  CameraViewController.m
//  FaceDetection
//
//  Created by mostafizur on 5/3/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "MSCameraViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface MSCameraViewController (){
    TCCameraSession *captureSession;
    AVCaptureVideoPreviewLayer *previewLayer;
    BOOL glcontextSetupCompleted;
}
@end

@implementation MSCameraViewController

-(void)didImageRotationCompleted:(UIImage *)capturedImage{
    
}

- (void)didEndVideoAssetWriting:(NSURL *)videoPathUrl {
//    RSShareViewController *sviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
//    sviewController.videoUrl = videoPathUrl;
//    [self.navigationController pushViewController:sviewController animated:YES];
}

-(void)didCancelVideo{
    
}

- (IBAction)shouldApplyThreshold:(UISwitch *)sender {
    self.glk_maskView.shouldApplyThreshold = [sender isOn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(captureVideo:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.2;
    [self.view addGestureRecognizer:longPress];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if(!glcontextSetupCompleted){
        glcontextSetupCompleted = [self.glk_maskView setupOpenGLContext];
//        captureSession = [[TCCameraSession alloc] init];
//        [captureSession initSessionWithView:self.view];
//        captureSession.glk_maskView = self.glk_maskView;
//        glcontextSetupCompleted = YES;
//    }
//    [captureSession startSession];
//    [self.glk_maskView setVideoDelegate:self];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [captureSession stopSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private methods



- (IBAction)captureImage:(id)sender {
    [captureSession capturePhoto];
    NSLog(@"capture image");
}
- (IBAction)captureVideo:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended");
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press detected.");
    }
}

@end
