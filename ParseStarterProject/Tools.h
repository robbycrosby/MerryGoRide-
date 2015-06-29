//
//  Tools.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/4/15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/Quartzcore.h>
#import <Parse/Parse.h>


@interface Tools : UIViewController

+(void)roundbutton:(UIButton*)button :(CGFloat)radius;
+(void)roundlabel:(UILabel*)label :(CGFloat)radius;
+(void)roundimage:(UIImageView*)label :(CGFloat)radius;
+(void)shadowbutton:(UIButton*)button;
+(void)shadowlabel:(UILabel*)label;
+(void)bigshadow:(UILabel*)label;
+(void)applyblur:(UIView*)view :(UIBlurEffectStyle)blur;


@end
