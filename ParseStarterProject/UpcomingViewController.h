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

@interface UpcomingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    NSArray *upcoming;
    __weak IBOutlet UILabel *statusbar;
    __weak IBOutlet UITableView *table;
    __weak IBOutlet UILabel *menu;
}



@end
