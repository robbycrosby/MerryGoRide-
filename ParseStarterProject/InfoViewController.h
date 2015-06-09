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
#import <GoogleMaps/GoogleMaps.h>


@class UICRouteOverlayMapView;

@interface InfoViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
    MKPlacemark *allocpick,*allocend;
    CLPlacemark *startspot,*endspot;
    MKRoute *routeDetails;
    NSArray* routes;
    BOOL isUpdatingRoutes;
    CLLocationManager *locationManager;
     PFGeoPoint* userloc;
    CLLocation *astart,*aend,*userlocation;
    float startlat,startlong,endlat,endlong;
    
}
@property (nonatomic) double startlat;
@property (nonatomic) double startlon;
@property (nonatomic) double endlat;
@property (nonatomic) double endlon;
@property (weak, nonatomic) IBOutlet MKMapView *mapkit;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *pickup;
@property (nonatomic) PFObject *ride;

@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;
@property (nonatomic, retain) NSArray *wayPoints;
@property (weak, nonatomic) IBOutlet UILabel *block;

@end
