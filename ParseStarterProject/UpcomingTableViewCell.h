//
//  UpcomingTableViewCell.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/5/15.
//
//

#import <UIKit/UIKit.h>

@interface UpcomingTableViewCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UILabel *to;
@property (weak, nonatomic) IBOutlet UILabel *when;
@property (weak, nonatomic) IBOutlet UILabel *sentence;
@property (weak, nonatomic) IBOutlet UILabel *card;

@end
