//
//  ScheduleViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface ScheduleViewController : UIViewController {
    UIDatePicker *dateselect;
    NSDate *pdate;
}
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *menu;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *back;
- (IBAction)back:(id)sender;


// Fields (Names)
@property (weak, nonatomic) IBOutlet UITextField *p1;
@property (weak, nonatomic) IBOutlet UITextField *p2;
@property (weak, nonatomic) IBOutlet UITextField *p3;
@property (weak, nonatomic) IBOutlet UITextField *p4;
@property (weak, nonatomic) IBOutlet UITextField *p5;

// Fields (Addresses)
@property (weak, nonatomic) IBOutlet UITextField *pickupaddress;
@property (weak, nonatomic) IBOutlet UITextField *pickupcity;
@property (weak, nonatomic) IBOutlet UITextField *pickupstate;
@property (weak, nonatomic) IBOutlet UITextField *pickupzip;
@property (weak, nonatomic) IBOutlet UITextField *destinationaddress;
@property (weak, nonatomic) IBOutlet UITextField *destinationcity;
@property (weak, nonatomic) IBOutlet UITextField *destinationstate;
@property (weak, nonatomic) IBOutlet UITextField *destinationzip;
@property (weak, nonatomic) IBOutlet UITextField *pickupname;
@property (weak, nonatomic) IBOutlet UITextField *destinationname;
@property (weak, nonatomic) IBOutlet UITextField *pickuptime;
@property (strong,nonatomic) UIDatePicker *datePicker;
- (IBAction)confirm:(id)sender;
- (IBAction)setpickup:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *setdate;
@property (weak, nonatomic) IBOutlet UIButton *ridedone;
- (IBAction)ridedone:(id)sender;

@end
