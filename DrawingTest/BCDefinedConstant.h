//
//  BCDefinedConstant.h
//  BucketCam
//
//  Created by Mostafizur Rahman on 5/24/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#ifndef BCDefinedConstant_h
#define BCDefinedConstant_h
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define STICKER_CATEGORY [NSArray arrayWithObjects: @"Eye", @"Head", @"Moustech", @"Beard", @"FullFace", nil] // best be serial according to view impelemntation
typedef NS_ENUM(NSInteger, FDStickerType) {
    FDStickerTypeHead,
    FDStickerTypeEye,
    FDStickerTypeBeard,
    FDStickerTypeMoustech,
    FDStickerTypeFullFace
};


typedef NS_ENUM(NSInteger, BCBrushBlendMode) {
    BCBrushBlendModeFadedInsideOut,     // Gradient Brush inside alpha 1 to outside 0
    BCBrushBlendModeHarderEdged,      // Whole image 0 alpha
    BCBrushBlendModeAlphaBlend, // % of alpha
    BCBrushBlendModeSquared
};



typedef NS_ENUM(NSInteger, BCPencilType) {
    BCPencilTypeDefault = 1090,     // Sharp pencil
    BCPencilTypeRound = 1091,      // rounded pencil
    BCPencilTypeMarker = 1092,       // \ type pencile same as MARKER
    BCPencilTypeEraserCircle = 1093,
    BCPencilTypeEraserTraingle = 1094,
    BCPencilTypeEraserRectangle = 1095
};

typedef NS_OPTIONS(NSUInteger, BCDataSourceType) {
    BCEditorType = 3521,
    BCAdjustmentType = 9741,
    BCFilterType = 7125
};

typedef NS_OPTIONS(NSUInteger, CMShareMediaType) {
    CMShareMediaFacebook = 787,
    CMShareMediaTwitter = 789,
    CMShareMediaInstagram = 790,
    CMShareMediaMore = 791
};


#define BOTTOM_MERGINE 5


#define MEDIATAG_SWPING 94520
#define MEDIATAG_SRCIMG 94521
#define MEDIATAG_EDTRVW 94522
#define MEDIATAG_IMAGE 12129
#define MEDIATAG_BRUSH 32562
#define MEDIATAG_VSLDE0 7417
#define MEDIATAG_VSLDE1 3693
#define MEDIATAG_ACTIVITY 35782

#define MEDIATAG_HEADERTITLE 14524
#define IDENTIFIER_MEDIACELL @"MediaCell"
#define IDENTIFIER_MEDIACOLL @"AlbumViewController"
#define IDENTIFIER_HEADRCELL @"MediaHeder"
#define IDENTIFIER_MEDIACONT @"ContentViewController"
#define IDENTIFIER_MEDIAPAGE @"PageViewController"
#define IDENTIFIER_MEDIAEDIT @"EditViewController"

#define ANIMKEYPATH_TEXTFIELD @"animateTextField"

#define LINEWIDTH_HEADER 0.75
#define ANIMATION_DURATION 0.4


#pragma -mark DEFINE FUCTIONS

#define THEME_UICOLOR [UIColor colorWithRed:(148.0f / 255.0f) green:(0.0f / 255.0f) blue:(148.0f / 255.0f) alpha:1.0f]

#define DRAGVIEW_CENTERX draggingView.center.x
#define DRAGVIEW_CENTERY draggingView.center.y
#define DRAGVIEW_ORIGINX draggingView.frame.origin.x
#define DRAGVIEW_ORIGINY draggingView.frame.origin.y
#define DRAGVIEW_WIDTH draggingView.frame.size.width
#define DRAGVIEW_HEIGHT draggingView.frame.size.height

#define DRSPRVIW_WIDTH self.frame.size.width
#define DRSPRVIW_HEIGHT self.frame.size.height

#define DRAGVIEW_HLFWDTH DRAGVIEW_WIDTH / 2
#define DRAGVIEW_HLFHGHT DRAGVIEW_HEIGHT / 2


#define SHOULD_ANIMATE_DRAGVIEW DRAGVIEW_ORIGINX < 0 || DRAGVIEW_ORIGINY < 0 ||\
DRAGVIEW_ORIGINX + DRAGVIEW_WIDTH > DRSPRVIW_WIDTH ||\
DRAGVIEW_ORIGINY + DRAGVIEW_HEIGHT > DRSPRVIW_HEIGHT

#define DRAGVIEW_CENTERPOINT CGPointMake(DRAGVIEW_CENTERX < DRAGVIEW_HLFWDTH ? DRAGVIEW_WIDTH / 2:\
(DRAGVIEW_CENTERX + DRAGVIEW_HLFWDTH > DRSPRVIW_WIDTH ?\
DRSPRVIW_WIDTH - DRAGVIEW_HLFWDTH : DRAGVIEW_CENTERX) ,\
DRAGVIEW_CENTERY + DRAGVIEW_HLFHGHT > DRSPRVIW_HEIGHT ?\
DRSPRVIW_HEIGHT - DRAGVIEW_HLFHGHT :\
(DRAGVIEW_CENTERY - DRAGVIEW_HLFHGHT < 0 ?\
DRAGVIEW_HLFHGHT : DRAGVIEW_CENTERY))

#define VIEWTAG_EMOGADGET 34010
#define VIEWTAG_SWIPECOLOR 34011
#define VIEWTAG_IMAGEVIEW 34012
#define VIEWTAG_DRAWINGVIEW 34013
#define VIEWTAG_COLORHOLDER 12912
#define VIEWTAG_COLORPOP 12192



#define DEFAULT_LEFTSPACE 90.0
#define DEFAULT_RIGHTSPACE 160
#define DEFAULT_BORDERWIDTH 1.75
#define COLLECTIONVIEW_CELLPADDING 5


#define THEME_SELECT [[UIColor greenColor] CGColor]
#define THEME_CGCLEAR [[UIColor clearColor] CGColor]
#define THEME_CGCOLOR [THEME_UICOLOR CGColor]
#define MAIN_SCREEN [[UIScreen mainScreen] bounds]
#define MAINSCRN_SIZE MAIN_SCREEN.size
#define MAINSCRN_HEIGHT MAINSCRN_SIZE.height
#define MAINSCRN_WIDTH MAINSCRN_SIZE.width
#define HALFMNSCRN_WIDTH MAINSCRN_WIDTH / 2
#define HALFMNSCRN_HEIGHT MAINSCRN_HEIGHT / 2
#define MAINSCRN_RATIO MAINSCRN_HEIGHT / MAINSCRN_WIDTH
#define MAINSCRN_CENTER CGPointMake(HALFMNSCRN_WIDTH, HALFMNSCRN_HEIGHT)
#define MAINSCRN_SCALE [[UIScreen mainScreen] scale]

#define EMORECT_WIDTH 80
#define PENFRAME_OFFSET 2
#define UIBLACK_COLOR [UIColor blackColor]
#define UIGRAY_COLOR [UIColor grayColor]

#define RANDOM_EMORECT(ratio, p_rect) (CGRectMake(RANDOM_INTEGER(10, p_rect.size.width / 2 - 20),\
RANDOM_INTEGER(10, p_rect.size.height / 2 - 20), EMORECT_WIDTH, EMORECT_WIDTH / ratio))


#define TXTVIEW_RECT CGRectMake(0, MAINSCRN_HEIGHT / 2 - 15, MAINSCRN_WIDTH, 30)
#define MIDPOINT_RECT(rect) (CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)))




#define RANDOM_INTEGER(low_bound, high_bound) (((float)arc4random() / 0x100000000) * (high_bound - low_bound) + low_bound)

#define RANDOM_UICOLOR [UIColor colorWithRed:\
(RANDOM_INTEGER(0,255)/255.0f)\
green:(RANDOM_INTEGER(0,255)/255.0f)\
blue:(RANDOM_INTEGER(0,255)/255.0f)\
alpha:RANDOM_INTEGER(20,150)/255.0f]



#define EDITORCOUNT_IMGVIEW (MAINSCRN_WIDTH > 320 ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 12 : 8) : 5) // more than iphone 5 scrren 9 images otherwise 6 images
#define COLLECTIONVIEW_ITEMPERROW (MAINSCRN_WIDTH > 320 ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6 : 4) : 2) // more than iphone 5 scrren 9
#define RANDOM_CGCOLOR [RANDOM_UICOLOR CGColor]















#pragma mark _ADD_GROUP

#define ADD_UNITID_BANNERVIEW @"ca-app-pub-3940256099942544/2934735716"
#define ADD_UNITID_INTERSTITIAL @"ca-app-pub-3940256099942544/4411468910"
#define ADD_DEVICEID @"befc4842ab25ad64304c5e0f49bc76d91c476bed"



#endif /* BCDefinedConstant_h */
