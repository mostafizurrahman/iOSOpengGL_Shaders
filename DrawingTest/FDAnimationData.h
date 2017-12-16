//
//  FDAnimationData.h
//  FaceDetection
//
//  Created by Paradox Lab on 12/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDAnimationData : NSObject
@property (readwrite) NSString *animBackground;//eaither PNG image name or animation image name
@property (readwrite) NSString *animationName;//eaither PNG image name or animation image name
//##in case of animation other index should be added to get original animation image path
@property (readwrite) double animationDuration; // time interval bettween two consicutive animation image fames
@property (readwrite) long frameCount; // number of image files to animate

-(instancetype)initWithData:(NSDictionary *)animationData;
@end
