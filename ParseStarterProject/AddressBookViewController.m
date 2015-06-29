//
//  AddressBookViewController.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/18/15.
//
//

#import "AddressBookViewController.h"

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [self getbook];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return addresses.count;
}

-(void)getbook{
    PFQuery *query = [PFQuery queryWithClassName:@"AddressBook"];
    [query orderByDescending:@"name"];
    [query whereKey:@"user" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"%lu",(unsigned long)objects.count);
            addresses = objects;
            [table reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
    PFObject *address = [addresses objectAtIndex:indexPath.row];
    cell.name.text = [address objectForKey:@"name"];
    cell.address.text = [address objectForKey:@"address"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *address = [addresses objectAtIndex:indexPath.row];
    NSString *location = [address objectForKey:@"address"];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = mapview.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 1200.0;
                         region.span.latitudeDelta /= 1200.0;
                         
                         [mapview setRegion:region animated:YES];
                         [mapview addAnnotation:placemark];
                     }
                 }
     ];
    map = [[CustomIOSAlertView alloc] init];

    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    mapview = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [customView addSubview:mapview];
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(0, 260, 300, 40)];
    [name setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [name setTextColor:[UIColor blackColor]];
    [name setTextAlignment:NSTextAlignmentCenter];
    [name setText:location];
    [Tools applyblur:name :UIBlurEffectStyleLight];
    [customView addSubview:name];
    [map setContainerView:customView];
    [map setDelegate:self];
    [map show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)new:(id)sender {
    map = [[CustomIOSAlertView alloc] init];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 125)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
    [title setFont:[UIFont boldSystemFontOfSize:17.0f]];
    title.text = @"New Address";
    [title setTextAlignment:NSTextAlignmentCenter];
    name = [[UITextField alloc] initWithFrame:CGRectMake(10, 43, 280, 30)];
    [name setFont:[UIFont systemFontOfSize:15.0f]];
    [name setTextColor:[UIColor darkGrayColor]];
    [name setTextAlignment:NSTextAlignmentCenter];
    [name setPlaceholder:@"Name The Location"];
    addy = [[UITextField alloc] initWithFrame:CGRectMake(10, 83, 280, 30)];
    [addy setFont:[UIFont systemFontOfSize:15.0f]];
    [addy setTextColor:[UIColor darkGrayColor]];
    [addy setTextAlignment:NSTextAlignmentCenter];
    [addy setPlaceholder:@"Address Goes Here"];
    [customView addSubview:name];
    [customView addSubview:title];
    [customView addSubview:addy];
    [map setContainerView:customView];
    [map setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Create", nil]];
    [map setDelegate:self];
    [map show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [map close];
    } else {
        PFObject *gameScore = [PFObject objectWithClassName:@"AddressBook"];
        gameScore[@"name"] = name.text;
        gameScore[@"address"] = addy.text;
        gameScore[@"user"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [map close];
                [RKDropdownAlert title:@"Address Saved" message:nil backgroundColor:[UIColor colorWithRed:0.263 green:0.627 blue:0.278 alpha:1] textColor:[UIColor whiteColor] time:2];
                [self getbook];
            } else {
                NSString *sname = name.text;
                NSString *saddy = addy.text;
                [map close];
                [RKDropdownAlert title:@"Error Saving" message:@"Try Again" backgroundColor:[UIColor colorWithRed:0.957 green:0.263 blue:0.212 alpha:1] textColor:[UIColor whiteColor] time:2];
                map = [[CustomIOSAlertView alloc] init];
                
                UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 20)];
                [title setFont:[UIFont boldSystemFontOfSize:17.0f]];
                title.text = @"New Address";
                [title setTextAlignment:NSTextAlignmentCenter];
                name = [[UITextField alloc] initWithFrame:CGRectMake(10, 49, 280, 30)];
                [name setFont:[UIFont systemFontOfSize:15.0f]];
                [name setTextColor:[UIColor darkGrayColor]];
                [name setTextAlignment:NSTextAlignmentCenter];
                [name setText:sname];
                addy = [[UITextField alloc] initWithFrame:CGRectMake(10, 89, 280, 30)];
                [addy setFont:[UIFont systemFontOfSize:15.0f]];
                [addy setTextColor:[UIColor darkGrayColor]];
                [addy setTextAlignment:NSTextAlignmentCenter];
                [addy setText:saddy];
                [customView addSubview:name];
                [customView addSubview:title];
                [customView addSubview:addy];
                [map setContainerView:customView];
                [map setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Create", nil]];
                [map setDelegate:self];
                [map show];
            }
        }];
        
    }
    
}
@end
