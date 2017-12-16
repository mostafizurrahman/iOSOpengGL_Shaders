//
//  BCStickerInterface.h
//  BucketCam
//
//  Created by Paradox Lab on 12/4/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@protocol BCStickerInterface<NSObject>
@required
-(CGRect)getMaskRendererRect:(CIFaceFeature *)faceFeature sourceImageSize:(const CGSize)imageSize;
-(CGFloat)degreesToRadians:(const CGFloat)degree;
-(UIImage *)getOriginalImage;
-(UIImage *)getIconImage;
-(instancetype)initWithData:(NSDictionary *)sdata;
-(CGFloat)getFaceHeight;
-(CGFloat)getFaceRadian;
@end
