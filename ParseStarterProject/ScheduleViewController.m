//
//  ScheduleViewController.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [Tools shadowlabel:_menu];
    [Tools roundbutton:_next :7.0f];
    [_p1 becomeFirstResponder];
    [super viewDidLoad];
    
    
    [_scroll setContentSize:CGSizeMake(960, 284)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)cancel:(id)sender {
    [_p1 resignFirstResponder];
    [_p2 resignFirstResponder];
    [_p3 resignFirstResponder];
    [_p4 resignFirstResponder];
    [_p5 resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)next:(id)sender {
    if (_scroll.contentOffset.x == 0) {
        if (_p1.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You need at least one rider"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [alert show];
            int duration = 1; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
        } else {
            [_scroll setContentOffset:CGPointMake(_scroll.contentOffset.x + 320, 0) animated:YES];
            _back.enabled = YES;
        }
    }
    if (_scroll.contentOffset.x == 320) {
        if ((_pickupaddress.text.length < 1) || (_pickupcity.text.length < 1) || (_pickupstate.text.length < 1) || (_pickupzip.text.length < 1) || (_destinationaddress.text.length < 1) || (_destinationcity.text.length < 1) || (_destinationstate.text.length < 1) || (_destinationzip.text.length < 1) || (_destinationname.text.length < 1) || (_pickupname.text.length < 1)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"You're forgetting something"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [alert show];
            int duration = 1; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });

        } else {
            [_scroll setContentOffset:CGPointMake(_scroll.contentOffset.x + 320, 0) animated:YES];
            _back.enabled = YES;
        }
       
        
    }
    if (_scroll.contentOffset.x == 640) {
        [_pickuptime becomeFirstResponder];
        _setdate.hidden = false;
        dateselect = [[UIDatePicker alloc] init];
        dateselect.datePickerMode = UIDatePickerModeDateAndTime;
        pdate = dateselect.date;
        [dateselect addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _pickuptime.inputView = dateselect;
        _back.enabled = YES;
        nil;
    }
    
}

-(void)submit{
    NSDate *pickup = pdate;
    PFObject *gameScore = [PFObject objectWithClassName:@"Upcoming"];
    gameScore[@"username"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    gameScore[@"fromAddress"] = [NSString stringWithFormat:@"%@ %@, %@ %@",_pickupaddress.text,_pickupcity.text,_pickupstate.text,_pickupzip.text];
    gameScore[@"From"] = _pickupname.text;
    gameScore[@"toAddress"] = [NSString stringWithFormat:@"%@ %@, %@ %@",_destinationaddress.text,_destinationcity.text,_destinationstate.text,_destinationzip.text];
    gameScore[@"To"] = _destinationname.text;
    gameScore[@"Date"] = pickup;
    gameScore[@"Kid1"] = _p1.text;
    gameScore[@"Kid2"] = _p2.text;
    gameScore[@"Kid3"] = _p3.text;
    gameScore[@"Kid4"] = _p4.text;
    gameScore[@"Kid5"] = _p5.text;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Processing"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show]; // duration in seconds


    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.00 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
            UIAlertView *butt = [[UIAlertView alloc] initWithTitle:@"Complete"
                                                            message:@"Your ride has been added to the queue and is awaiting a driver. You will be notified when a driver accepts the ride."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [butt show];
            int duration = 1; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [butt dismissWithClickedButtonIndex:0 animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            });

        } else {
            // There was a problem, check error.description
        }
    }];
}
- (IBAction)confirm:(id)sender {
    [_pickuptime resignFirstResponder];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    NSDate *now = [[NSDate alloc] init];
    now = dateselect.date;
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    _pickuptime.text = [NSString stringWithFormat:@"%@ at %@",theDate,theTime];
    _setdate.hidden = true;
    _ridedone.hidden = false;
}

- (IBAction)setpickup:(id)sender {
    _setdate.hidden = false;
    dateselect = [[UIDatePicker alloc] init];
    dateselect.datePickerMode = UIDatePickerModeDateAndTime;
    pdate = dateselect.date;
    [dateselect addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _pickuptime.inputView = dateselect;
}

- (void)datePickerValueChanged:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    NSDate *now = [[NSDate alloc] init];
    now = picker.date;
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    pdate = picker.date;
    [_pickuptime setText:[NSString stringWithFormat:@"%@ at %@",theDate,theTime]];
    
    
}
- (IBAction)back:(id)sender {
    [_scroll setContentOffset:CGPointMake(_scroll.contentOffset.x - 320, 0) animated:YES];
}

- (IBAction)ridedone:(id)sender {
    [self submit];
}
@end
