//
//  UpcomingViewController.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import "UpcomingViewController.h"

@interface UpcomingViewController ()

@end

@implementation UpcomingViewController

- (void)viewDidLoad {
    [_menu setContentSize:CGSizeMake(557, 0)];
    [_menu setContentOffset:CGPointMake(257, 0)];
    table.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    [self getupcoming];
    [Tools shadowlabel:menu];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refreshControl];
    CLLocationCoordinate2D zoom = CLLocationCoordinate2DMake(37.331711, -122.030184);
    [map setCenterCoordinate:zoom  animated:YES];
    [Tools applyblur:blur :UIBlurEffectStyleDark];
    [Tools applyblur:blur2 :UIBlurEffectStyleDark];
    [Tools applyblur:blur3 :UIBlurEffectStyleDark];
    MKCoordinateRegion region;
    // <LATITUDE> and <LONGITUDE> for Cupertino, CA.
    
    region = MKCoordinateRegionMake(zoom, MKCoordinateSpanMake(0.5, 0.5));
    // 0.5 is spanning value for region, make change if you feel to adjust bit more
    
    MKCoordinateRegion adjustedRegion = [map regionThatFits:region];
    [map setRegion:adjustedRegion animated:YES];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [_menu setContentSize:CGSizeMake(557, 0)];
    [_menu setContentOffset:CGPointMake(257, 0)];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (_isRefreshing == YES) {
        [self getupcoming];
        _isRefreshing = NO;
    }
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self getupcoming];
    [refreshControl endRefreshing];
}

-(void)getupcoming{
    PFQuery *query = [PFQuery queryWithClassName:@"Upcoming"];
    [query orderByAscending:@"Date"];
    [query whereKey:@"username" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            upcoming = objects;
            [table reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return upcoming.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 158;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"UpcomingTableViewCell";
    
    UpcomingTableViewCell *cell = (UpcomingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    PFObject *object = [upcoming objectAtIndex:indexPath.row];
    cell.from.text = [object objectForKey:@"From"];
    cell.to.text = [object objectForKey:@"To"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    [Tools applyblur:cell.card :UIBlurEffectStyleDark];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    NSDate *now = [[NSDate alloc] init];
    now = [object objectForKey:@"Date"];
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
        cell.when.text = [NSString stringWithFormat:@"%@ at %@",theDate,theTime];
    cell.backgroundColor = [UIColor clearColor];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hey");
    //Change the selected background view of the cell.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    InfoViewController *myVC = (InfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Info"];
    PFObject *ride = [upcoming objectAtIndex:indexPath.row];
    myVC.ride = ride;
    [self presentViewController:myVC animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (IBAction)showmenu:(id)sender {
    if (_menu.contentOffset.x == 257) {
        [_menu setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [_menu setContentOffset:CGPointMake(257, 0) animated:YES];
    }
}




















@end
