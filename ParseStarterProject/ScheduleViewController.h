//
//  ScheduleViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "RKDropDownAlert.h"
#import "CustomIOSAlertView.h"
#import "CheckoutViewController.h"
#import "AddressBookTableViewCell.h"

@interface ScheduleViewController : UIViewController <UISearchBarDelegate,CustomIOSAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *annotations;
    UIDatePicker *dateselect;
    NSDate *pdate;
    double startlat,startlon,endlat,endlon;
    NSNumber *miles,*calccost;
    UIAlertView *processing;
    NSString *start,*end;
    double ridersamount;
    double riders;
    double milesa,milesb;
    CustomIOSAlertView *ridedate;
    NSString *ridedatestring;
    CLPlacemark *startloc,*endloc;
    NSArray *address;
}
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *menu;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *back;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *pickup_map;
@property (weak, nonatomic) IBOutlet UISearchBar *pickup_add;
- (IBAction)destination:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkout;
- (IBAction)checkout:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextbutton;
@property (weak, nonatomic) IBOutlet UIButton *addressbook;
- (IBAction)instertaddress:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;


@end
