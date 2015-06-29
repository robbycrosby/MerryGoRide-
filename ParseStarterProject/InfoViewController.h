//
//  InfoViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/8/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "Tools.h"
#import "RouteTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomIOSAlertView.h"


@class UICRouteOverlayMapView;

@interface InfoViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,CustomIOSAlertViewDelegate> {
    MKRoute *routeDetails;
    NSArray* routes;
    BOOL isUpdatingRoutes;
    CLLocationManager *locationManager;
     PFGeoPoint* userloc;
    CLLocation *astart,*aend,*userlocation;
    double startlat,startlon,endlat,endlon;
    NSMutableArray *atdist,*ataction;
    NSNumber *miles;
    CustomIOSAlertView *driverInfo;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapkit;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *pickup;
@property (nonatomic) PFObject *ride;

@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;
@property (nonatomic, retain) NSArray *wayPoints;
@property (weak, nonatomic) IBOutlet UILabel *block;
- (IBAction)back:(id)sender;
- (IBAction)start:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *blur;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *distancetitle;
@property (weak, nonatomic) IBOutlet UILabel *menubar;

@end
