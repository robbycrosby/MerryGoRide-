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
    annotations = [[NSMutableArray alloc] init];
    [Tools shadowlabel:_menu];
    [Tools roundbutton:_next :7.0f];
    [super viewDidLoad];
    [_pickup_map setDelegate:self];

    [_scroll setContentSize:CGSizeMake(960, 284)];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Enter The Number of Passengers."
                                                    message:@"Maximum 5"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
    [alert show];
    PFQuery *query = [PFQuery queryWithClassName:@"AddressBook"];
    [query orderByDescending:@"name"];
    [query whereKey:@"user" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"%lu",(unsigned long)objects.count);
            address = objects;
            [_table reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        riders = [alertView textFieldAtIndex:0].text.doubleValue;
        
        ridersamount = riders * 2.50;
        ridedate = [[CustomIOSAlertView alloc] init];
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        dateselect = [[UIDatePicker alloc] initWithFrame:CGRectMake(-5, 10, 300, 180)];
        dateselect.datePickerMode = UIDatePickerModeDateAndTime;
        
        pdate = dateselect.date;
        [dateselect addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [customView addSubview:dateselect];
        [ridedate setContainerView:customView];
        [ridedate setDelegate:self];
        [ridedate setButtonTitles:[NSMutableArray arrayWithObjects:@"Confirm Date", nil]];
        [ridedate show];
        // Insert whatever needs to be done with "name"
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    ridedatestring = [NSString stringWithFormat:@"%@ at %@",theDate,theTime];
        pdate = picker.date;
    
    
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [ridedate close];
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0"];
        NSNumber *roundedriders = [fmt numberFromString:[fmt stringFromNumber:[NSNumber numberWithDouble:riders]]];
        riders = riders * 2.50;
        [RKDropdownAlert title:nil message:[NSString stringWithFormat:@"Trip is for %@ passengers on %@",roundedriders, ridedatestring] backgroundColor:[UIColor colorWithRed:0.263 green:0.627 blue:0.278 alpha:1] textColor:[UIColor whiteColor] time:3];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (start.length < 1) {
        NSString *starta = searchBar.text;
        CLGeocoder *startcoder = [[CLGeocoder alloc] init];
        [startcoder geocodeAddressString:starta
                       completionHandler:^(NSArray* placemarks, NSError* error){
                           if (placemarks && placemarks.count > 0) {
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                               start = [NSString stringWithFormat:@"%@ %@, %@ %@",placemark.name,placemark.locality,placemark.administrativeArea,placemark.postalCode];
                               MKCoordinateRegion region = _pickup_map.region;
                               region.center = placemark.region.center;
                               region.span.longitudeDelta /= 500.0;
                               region.span.latitudeDelta /= 500.0;
                               startlat = placemark.coordinate.latitude;
                               startlon = placemark.coordinate.longitude;
                               [_pickup_map setRegion:region animated:YES];
                               [searchBar resignFirstResponder];
                               [_pickup_map addAnnotation:placemark];
                               [annotations addObject:placemark];
                               
                           }
                       }
         ];
    } else {
        NSString *startb = searchBar.text;
        CLGeocoder *startcoder = [[CLGeocoder alloc] init];
        [startcoder geocodeAddressString:startb
                       completionHandler:^(NSArray* placemarks, NSError* error){
                           if (placemarks && placemarks.count > 0) {
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                               end = [NSString stringWithFormat:@"%@ %@, %@ %@",placemark.name,placemark.locality,placemark.administrativeArea,placemark.postalCode];
                               NSLog(end);
                               MKCoordinateRegion region = _pickup_map.region;
                               region.center = placemark.region.center;
                               region.span.longitudeDelta /= 500.0;
                               region.span.latitudeDelta /= 500.0;
                               endlat = placemark.coordinate.latitude;
                               endlon = placemark.coordinate.longitude;
                               [_pickup_map setRegion:region animated:YES];
                               [searchBar resignFirstResponder];
                               [_pickup_map addAnnotation:placemark];
                               [annotations addObject:placemark];
                               
                           }
                       }
         ];
    }
    
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
            [_pickup_map showAnnotations:annotations animated:YES];
            _pickup_map.camera.altitude *= 2.0;
            milesa = rout.distance * 0.00062137;
            NSLog(@"%f",milesa);
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"0.###"];
            miles = [fmt numberFromString:[fmt stringFromNumber:[NSNumber numberWithDouble:milesa]]];
            double totalcosta = miles.doubleValue  *1.8700 ;
            double totalcostb =totalcosta + 11.000;
            calccost = [fmt numberFromString:[fmt stringFromNumber:[NSNumber numberWithDouble:totalcostb]]];
            UIAlertView *cost = [[UIAlertView alloc] initWithTitle:@"Trip Cost" message:[NSString stringWithFormat:@"$%.2f",totalcostb] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [processing dismissWithClickedButtonIndex:0 animated:YES];
            [cost show];
            
            
        }];
    }];
}


-(void)submit{
    
    //NSString *start = [NSString stringWithFormat:@"%@ %@, %@ %@",_pickupaddress.text,_pickupcity.text,_pickupstate.text,_pickupzip.text];
    CLGeocoder *startcoder = [[CLGeocoder alloc] init];
    [startcoder geocodeAddressString:start
                   completionHandler:^(NSArray* placemarks, NSError* error){
                       if (placemarks && placemarks.count > 0) {
                           CLPlacemark *topResult = [placemarks objectAtIndex:0];
                           MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                           startloc = placemark;
                           
                           startlat = placemark.coordinate.latitude;
                           startlon = placemark.coordinate.longitude;
                          
                           
                           
                       }
                   }
     ];
    //NSString *end = [NSString stringWithFormat:@"%@ %@, %@ %@",_destinationaddress.text,_destinationcity.text,_destinationstate.text,_destinationzip.text];
    CLGeocoder *endcoder = [[CLGeocoder alloc] init];
    [endcoder geocodeAddressString:end
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         endloc = placemark;
       
                         
                         endlat = placemark.coordinate.latitude;
                         endlon = placemark.coordinate.longitude;
                         [NSTimer scheduledTimerWithTimeInterval:2.0
                                                          target:self
                                                        selector:@selector(returncost)
                                                        userInfo:nil
                                                         repeats:NO];
                     }
                 }
     ];
    processing = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Calculating Cost..."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [processing show]; // duration in seconds
    /*
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
     */
}
/*
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
*/

- (IBAction)back:(id)sender {
    [_scroll setContentOffset:CGPointMake(_scroll.contentOffset.x - 320, 0) animated:YES];
}

- (IBAction)ridedone:(id)sender {
    [self submit];
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

- (IBAction)destination:(id)sender {
    if ((start.length > 1) && (end.length > 1)) {
        [RKDropdownAlert title:@"Calculating..." message:@"Determining Distance and Cost" ];
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
                [_pickup_map addOverlay:line];
                
                
                milesa = rout.distance * 0.00062137;
                NSLog(@"%f",milesa);
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                miles = [fmt numberFromString:[fmt stringFromNumber:[NSNumber numberWithDouble:milesa]]];
                double totalcosta = miles.doubleValue  *1.8700 ;
                double totalcostb =totalcosta + 11.000 + riders;
                calccost = [fmt numberFromString:[fmt stringFromNumber:[NSNumber numberWithDouble:totalcostb]]];
                [RKDropdownAlert title:[NSString stringWithFormat:@"Trip Cost: $%@",calccost] message:@"Before MerryGoRide Fee" backgroundColor:[UIColor colorWithRed:0.263 green:0.627 blue:0.278 alpha:1] textColor:[UIColor whiteColor] time:15];
                _checkout.hidden = NO;
                [_nextbutton setTitle:@""];
                _nextbutton.enabled=false;
            }];
        }];

    } else {
        [RKDropdownAlert title:@"Now Set The Destination" message:@"Enter Street, City for fastest results." backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor]];
        _pickup_add.text = @"";
        _pickup_add.placeholder = @"Destination Address";
    }
    
    
}


- (IBAction)checkout:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    CheckoutViewController *myVC = (CheckoutViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Checkout"];
    myVC.routecost = calccost;
    myVC.dateofride = pdate;
    myVC.startshortname = startloc.name;
    myVC.endshortname = endloc.name;
    myVC.passengers = riders;
    myVC.start = start;
    myVC.end = end;
    [self presentViewController:myVC animated:YES completion:nil];
    NSLog(@"Checkout");
}
- (IBAction)instertaddress:(id)sender {
    [UIView transitionWithView:_table
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    _table.hidden = NO;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return address.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AddressBookTableViewCell";
    
    AddressBookTableViewCell *cell = (AddressBookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressBookTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    PFObject *object = [address objectAtIndex:indexPath.row];
    cell.name.text = [object objectForKey:@"name"];
    cell.address.text = [object objectForKey:@"address"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *object = [address objectAtIndex:indexPath.row];
    if (start.length < 1) {
        NSString *starta = [object objectForKey:@"address"];
        _pickup_add.text = starta;
        CLGeocoder *startcoder = [[CLGeocoder alloc] init];
        [startcoder geocodeAddressString:starta
                       completionHandler:^(NSArray* placemarks, NSError* error){
                           if (placemarks && placemarks.count > 0) {
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                               start = [NSString stringWithFormat:@"%@ %@, %@ %@",placemark.name,placemark.locality,placemark.administrativeArea,placemark.postalCode];
                               MKCoordinateRegion region = _pickup_map.region;
                               region.center = placemark.region.center;
                               region.span.longitudeDelta /= 500.0;
                               region.span.latitudeDelta /= 500.0;
                               startlat = placemark.coordinate.latitude;
                               startlon = placemark.coordinate.longitude;
                               [_pickup_map setRegion:region animated:YES];
                               [_pickup_map addAnnotation:placemark];
                               [annotations addObject:placemark];
                               
                           }
                       }
         ];
    } else {
        NSString *startb = [object objectForKey:@"address"];
        _pickup_add.text = startb;
        CLGeocoder *startcoder = [[CLGeocoder alloc] init];
        [startcoder geocodeAddressString:startb
                       completionHandler:^(NSArray* placemarks, NSError* error){
                           if (placemarks && placemarks.count > 0) {
                               CLPlacemark *topResult = [placemarks objectAtIndex:0];
                               MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                               end = [NSString stringWithFormat:@"%@ %@, %@ %@",placemark.name,placemark.locality,placemark.administrativeArea,placemark.postalCode];
                               NSLog(end);
                               MKCoordinateRegion region = _pickup_map.region;
                               region.center = placemark.region.center;
                               region.span.longitudeDelta /= 500.0;
                               region.span.latitudeDelta /= 500.0;
                               endlat = placemark.coordinate.latitude;
                               endlon = placemark.coordinate.longitude;
                               [_pickup_map setRegion:region animated:YES];
                               [_pickup_map addAnnotation:placemark];
                               [annotations addObject:placemark];
                               
                           }
                       }
         ];
    }
    [UIView transitionWithView:_table
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    _table.hidden = YES;

}

@end
