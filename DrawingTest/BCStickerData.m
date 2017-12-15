//
//  BCStickerData.m
//  BucketCam
//
//  Created by Paradox Lab on 12/4/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "BCStickerData.h"
#define MAX_STICKER_HEIGHT 390


@interface BCStickerData (){
    
}
@end
@implementation BCStickerData
-(instancetype)initWithData:(NSDictionary *)stickerData{
    self = [super init];
    NSDictionary *maskAnimDictionary = [stickerData objectForKey:@"maskanimation"];
    self.stickerAnimation = [[FDAnimationData alloc] initWithData:maskAnimDictionary];
    NSDictionary *animationDictionary = [stickerData objectForKey:@"backgroundanimation"];
    self.backgroundAnimation = [[FDAnimationData alloc] initWithData:animationDictionary];

    self.ratio_originX = [[stickerData objectForKey:@"originx"] doubleValue] / MAX_STICKER_HEIGHT;NSString *orgy = [stickerData objectForKey:@"originy"];
    if([self.stickerAnimation.animationName containsString:@"head2"]){
        NSLog(@"%@", orgy);
    }
    self.ratio_originY = [orgy doubleValue] / MAX_STICKER_HEIGHT;
    self.ratio_width = [[stickerData objectForKey:@"widthratio"] doubleValue] / MAX_STICKER_HEIGHT;
    self.ratio_height = [[stickerData objectForKey:@"heightratio"] doubleValue] / MAX_STICKER_HEIGHT;
    self.iconName = [stickerData objectForKey:@"inconname"];
    return self;
}


















@end
