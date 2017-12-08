//
//  FDCameraRenderer.h
//  IPVFaceDetectioniOS
//
//  Created by Nishu on 1/2/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

/*!
    @class          FDCameraRenderer
    @abstract       Renders camera preview buffer
    @discussion     Renders camera preview buffer using OpenGL ES 2.0.
                    setCameraResolution: must be called before start rendering.
                    Call updateSampleBuffer: to update current camera preview
                    sample buffer
 */
@interface FDCameraRenderer : NSObject

/*!
    @method         setCameraResolution:
    @param          resolution
                    Camera preview resolution
    @discussion     Set camera preview resolution. This function must be called
                    before start rendering. Otherwise nothing will be rendered.
 */
- (void) setCameraResolution:(CGSize)resolution;

/*!
    @method         updateCameraData:UVData:
    @param          yPlaneData
                    Y plane data of camera preview to be updated
    @param          uvPlaneData
                    U and V plane data of camera preview to be updated. U and V
                    data are interleaved with V trailing U.
 */
- (void) updateCameraData:(const unsigned char* const) yPlaneData
                   UVData:(const unsigned char* const) uvPlaneData;

/*!
    @method         updateSampleBuffer:
    @abstract       Upates camera preview sample buffer
    @param          sampleBuffer
                    Current camera preview buffer
    @discussion     Call this function when camera preview changes and this buffer
                    will be rendered on next render cycle.
 */
- (void) updateSampleBuffer: (CMSampleBufferRef) sampleBuffer;

/*!
    @method         render
    @abstract       Renders camera preview buffer
    @discussion     Renders last updated camera preview sample buffer. Call updateSampleBuffer:
                    to update current camera preview sample buffer
 */
- (void) render;


@end
