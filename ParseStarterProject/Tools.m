//
//  Tools.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/4/15.
//
//

#import "Tools.h"

@interface Tools ()

@end

@implementation Tools

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)roundbutton:(UIButton *)button :(CGFloat)radius {
    button.layer.cornerRadius = radius;
    button.clipsToBounds = true;
}
+(void)roundlabel:(UILabel *)label :(CGFloat)radius {
    label.layer.cornerRadius = radius;
    label.clipsToBounds = true;
}
+(void)shadowbutton:(UIButton *)button{
    button.layer.masksToBounds = NO;
    button.layer.cornerRadius = 8; // if you like rounded corners
    button.layer.shadowOffset = CGSizeMake(-15, 20);
    button.layer.shadowRadius = 5;
    button.layer.shadowOpacity = 0.25;
}

+(void)shadowlabel:(UILabel *)label{
    label.layer.masksToBounds = NO;
    label.layer.cornerRadius = 8; // if you like rounded corners
    label.layer.shadowOffset = CGSizeMake(1, 3);
    label.layer.shadowRadius = 5;
    label.layer.shadowOpacity = 0.15;
}

+(void)bigshadow:(UILabel *)label{
    label.layer.masksToBounds = NO;
    label.layer.cornerRadius = 8; // if you like rounded corners
    label.layer.shadowOffset = CGSizeMake(1, 20);
    label.layer.shadowRadius = 5;
    label.layer.shadowOpacity = 0.25;
}

+(void)applyblur:(UIView*)view :(UIBlurEffectStyle)blur{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = view.bounds;
    [view addSubview:visualEffectView];
}


@end
