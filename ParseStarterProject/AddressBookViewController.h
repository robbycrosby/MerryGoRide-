//
//  AddressBookViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/18/15.
//
//

#import <UIKit/UIKit.h>
#import "AddressBookTableViewCell.h"
#import <Parse/Parse.h>
#import "CustomIOSAlertView.h"
#import <Mapkit/Mapkit.h>
#import "Tools.h"
#import "RKDropdownAlert.h"

@interface AddressBookViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CustomIOSAlertViewDelegate> {
    
    __weak IBOutlet UITableView *table;
    NSArray *addresses;
    CustomIOSAlertView *map;
    CustomIOSAlertView *add;
    MKMapView *mapview;
    UITextField *name,*addy;
}
- (IBAction)back:(id)sender;
- (IBAction)new:(id)sender;

@end
