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
    
    table.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
    [self getupcoming];
    [Tools shadowlabel:menu];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refreshControl];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    [Tools shadowlabel:cell.card];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    NSDate *now = [[NSDate alloc] init];
    now = [object objectForKey:@"Date"];
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
        cell.when.text = [NSString stringWithFormat:@"%@ at %@",theDate,theTime];
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0f];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    InfoViewController *myVC = (InfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Info"];
    PFObject *ride = [upcoming objectAtIndex:indexPath.row];
    myVC.ride = ride;
    [self presentViewController:myVC animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}






















@end
