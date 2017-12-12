//
//  CameraGLView.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/9/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "FDCameraRenderer.h"

@interface CameraGLView : GLKView

/*!
 True when face masking is active. It has to be set when user activate/deactivate
 face masking feature.
 */
@property (readwrite) BOOL renderMask;

/*!
 True when view is ready to render mask. It should be false when no face
 is detected. Otherwise mask will be rendered on wrong coordinates
 */
@property (readwrite) BOOL isReadyToRenderMask;

/*!
 @method         render
 @abstract       Renders mask
 @discussion     Renders mask on last predicted shape. This must be called in
 every render cycle and best to be called from
 GLKViewController::update method.
 */
- (void)render;

/*!
 @method         setCameraResolution:
 @abstract       Set the image resultion for drwing
 @param          resolution
 It is the pixel height width of the image in CGSize
 @param          shouldKeep
 If true, camera aspect ratio will be maintained while rendering.
 It will be rendered at the center of the veiw and top and bottom of the view
 may be rendered as black
 @discussion     This method can set pixel width height for glkview drawing.
 Width and height are set according to session preset of AVCaptureSession.
 */
- (void) setCameraResolution: (CGSize) resolution KeepAspectRatio:(BOOL)shouldKeep;

@property (readonly) FDCameraRenderer *cameraRender;



///*!
// @method         clearGL
// @abstract       Clear GL rendering
// @discussion     Finish remaining GL commands and stops rendering until initializeGL
// is called again. This must be called when application enters background
// */
//- (void) clearGL;
//
///*!
// @method         initializeGL
// @abstract       Initialize GL rendering
// @discussion     Makes the view ready to render until clearGL called. But it doesn't
// start rendering immediately but render method renders GL. This must
// be called when application enters foreground.
// */
//- (void) initializeGL;






@end
