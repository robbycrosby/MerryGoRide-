//
//  InfoViewController.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/8/15.
//
//

#import "InfoViewController.h"

@interface InfoViewController ()


@end

@implementation InfoViewController

- (void)viewDidLoad {
    [Tools bigshadow:_block];
    [super viewDidLoad];
    [self getdistance];
   
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)getdistance{
    NSString *start = [_ride objectForKey:@"fromAddress"];
    CLGeocoder *startcoder = [[CLGeocoder alloc] init];
    [startcoder geocodeAddressString:start
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         astart = [[CLLocation alloc] initWithLatitude:placemark.coordinate.latitude longitude:placemark.coordinate.longitude];
                         MKCoordinateRegion region = _mapkit.region;
                         _startlat = placemark.coordinate.latitude;
                         _startlon = placemark.coordinate.longitude;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 400.0;
                         region.span.latitudeDelta /= 400.0;
                         [_mapkit setRegion:region animated:YES];
                         
                         [_mapkit addAnnotation:placemark];
                         
                         
                     }
                 }
     ];
    NSString *end = [_ride objectForKey:@"toAddress"];
    CLGeocoder *endcoder = [[CLGeocoder alloc] init];
    [endcoder geocodeAddressString:end
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         aend = [[CLLocation alloc] initWithLatitude:placemark.coordinate.latitude longitude:placemark.coordinate.longitude];
                         _endlat = placemark.coordinate.latitude;
                         _endlon = placemark.coordinate.longitude;
                         MKCoordinateRegion region = _mapkit.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 400.0;
                         region.span.latitudeDelta /= 400.0;
                         NSLog(@"End: %f, %f", placemark.coordinate.latitude,placemark.coordinate.longitude);
                         
                        
                         [_mapkit setRegion:region animated:YES];
                         [_mapkit addAnnotation:placemark];
                     }
                 }
     ];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [UIColor orangeColor];
        aView.lineWidth = 20;
        return aView;
    }
    return nil;
}

-(void)getuserlocation{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            userloc = geoPoint;
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            userlocation = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
        [self getdistance];
        
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
