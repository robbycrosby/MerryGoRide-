//
//  StartusViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import <CoreLocation/CoreLocation.h>

@interface StartupViewController : UIViewController {
    
    CLLocationManager *request;
    __weak IBOutlet UIButton *signup;
    __weak IBOutlet UIButton *signin;
    
}

@end
