//
//  BCStickerData.h
//  BucketCam
//
//  Created by Paradox Lab on 12/4/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCStickerInterface.h"
#import "FDAnimationData.h"



@interface BCStickerData : NSObject
@property (readwrite) double ratio_originX;
@property (readwrite) double ratio_originY;
@property (readwrite) double ratio_width;
@property (readwrite) double ratio_height;
@property (readwrite) FDAnimationData *stickerAnimation;
@property (readwrite) FDAnimationData *backgroundAnimation;

@property (readwrite) NSString *iconName;

-(instancetype)initWithData:(NSDictionary *)stickerData;

@end
