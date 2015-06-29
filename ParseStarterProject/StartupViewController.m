//
//  StartusViewController.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import "StartupViewController.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

- (void)viewDidLoad {
    [Tools roundbutton:signin :6.0f];
    [Tools roundbutton:signup :6.0f];
    [request requestWhenInUseAuthorization];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
