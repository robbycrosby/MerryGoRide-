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
    [Tools roundlabel:_distancetitle :_distancetitle.frame.size.width/2];
    atdist = [[NSMutableArray alloc] init];
    ataction = [[NSMutableArray alloc] init];
    [Tools bigshadow:_block];
    [super viewDidLoad];
    [self getdistance];
    [_scroll setContentSize:CGSizeMake(320, 1136)];
    [Tools applyblur:_menubar :UIBlurEffectStyleDark];
    [Tools applyblur:_blur :UIBlurEffectStyleDark];
    
        // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)returncost{
    NSLog(@"Start: %f, %f",startlat,startlon);
    NSLog(@"End: %f, %f",endlat,endlon);
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(startlat, startlon) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(endlat, endlon) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [_mapkit addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            miles = [NSNumber numberWithDouble:rout.distance * 0.00062137];
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"0.#"];
            
            _distancetitle.text = [fmt stringFromNumber:miles];
            NSArray *steps = [rout steps];
            

            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
                [ataction addObject:[obj instructions]];
                double when = [obj distance] * 0.00062137;
                if (when < 0.75) {
                    when = when * 5280.0;
                    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                    NSNumber *x = [NSNumber numberWithDouble:when];
                    [fmt setPositiveFormat:@"0"];

                    [atdist addObject:[NSString stringWithFormat:@"%@ feet",[fmt stringFromNumber:x]]];
                } else {
                    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                    NSNumber *x = [NSNumber numberWithDouble:when];
                    [fmt setPositiveFormat:@"0"];

                    [atdist addObject:[NSString stringWithFormat:@"%@ miles",[fmt stringFromNumber:x]]];
                }
                
                if (atdist.count == steps.count) {
                    [_table reloadData];
                }
            }];
        }];
    }];
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
                           region.center = placemark.region.center;
                           region.span.longitudeDelta /= 500.0;
                           region.span.latitudeDelta /= 500.0;
                           startlat = placemark.coordinate.latitude;
                           startlon = placemark.coordinate.longitude;
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
                         
                         MKCoordinateRegion region = _mapkit.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 500.0;
                         region.span.latitudeDelta /= 500.0;
                         endlat = placemark.coordinate.latitude;
                         endlon = placemark.coordinate.longitude;
                         [NSTimer scheduledTimerWithTimeInterval:2.0
                                                          target:self
                                                        selector:@selector(returncost)
                                                        userInfo:nil
                                                         repeats:NO];
                         
                         
                         [_mapkit setRegion:region animated:YES];
                         [_mapkit addAnnotation:placemark];
                     }
                 }
     ];
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RouteTableViewCell";
    
    RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RouteTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.when.text = [atdist objectAtIndex:indexPath.row];
    cell.action.text = [ataction objectAtIndex:indexPath.row];
    //cell.action.text = @"Hey";
    cell.backgroundColor = [UIColor clearColor];
    cell.number.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ataction.count;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
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



- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)start:(id)sender {
    driverInfo = [[CustomIOSAlertView alloc] init];
    UIImageView *headshot = [[UIImageView alloc] initWithFrame:CGRectMake(85, 20, 80, 80)];
    headshot.image = [UIImage imageNamed:@"headshot.jpg"];
    [Tools roundimage:headshot :headshot.frame.size.width/2];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 180)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 250, 30)];
    title.text = @"Phil Shiller";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    UILabel *licenseplate = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 250, 25)];
    licenseplate.text = @"2007 Toyota Rav-4";
    [licenseplate setFont:[UIFont systemFontOfSize:15.0f]];
    [licenseplate setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:licenseplate];
     [customView addSubview:title];
    [customView addSubview:headshot];
    [driverInfo setContainerView:customView];
    [driverInfo setDelegate:self];
    [driverInfo setButtonTitles:[NSMutableArray arrayWithObjects:@"Message", @"Call", @"Cancel", nil]];
    [driverInfo show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *messsage = [[UIAlertView alloc] initWithTitle:@"Message"
                                                           message:@"This will send a message to the driver"
                                                          delegate:self cancelButtonTitle:@"Ok"
                                                 otherButtonTitles: nil];
        [messsage show];
    } else if (buttonIndex == 1) {
        UIAlertView *messsage = [[UIAlertView alloc] initWithTitle:@"Phone"
                                                           message:@"This will call the driver"
                                                          delegate:self cancelButtonTitle:@"Ok"
                                                 otherButtonTitles: nil];
        [messsage show];
    } else {
        [alertView close];
    }
}

@end
