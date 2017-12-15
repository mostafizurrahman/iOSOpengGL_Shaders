//
//  FDAnimationData.m
//  FaceDetection
//
//  Created by Paradox Lab on 12/7/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "FDAnimationData.h"

@implementation FDAnimationData
-(instancetype)initWithData:(NSDictionary *)animationData{
    self = [super init];
    NSString *value = [animationData valueForKey:@"duration"];
    self.animationDuration = [value doubleValue];
    value = [animationData valueForKey:@"imagecount"];
    self.frameCount = (long)[value intValue];
    self.animationName = [animationData valueForKey:@"filename"];
    return self;
}

@end
