//
//  UpcomingViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "UpcomingTableViewCell.h"
#import "InfoViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UpcomingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate> {
    CLLocationManager *location;
    
    NSArray *upcoming;
    __weak IBOutlet UILabel *statusbar;
    __weak IBOutlet UITableView *table;
    __weak IBOutlet UILabel *menu;
    __weak IBOutlet MKMapView *map;
    __weak IBOutlet UILabel *blur;
    __weak IBOutlet UILabel *blur2;
    __weak IBOutlet UILabel *blur3;
}
@property (weak, nonatomic) IBOutlet UIScrollView *menu;
- (IBAction)showmenu:(id)sender;

@property (nonatomic) BOOL isRefreshing;

@end
