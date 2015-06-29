//
//  RouteTableViewCell.h
//  
//
//  Created by Robert Crosby on 6/8/15.
//
//

#import <UIKit/UIKit.h>

@interface RouteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *when;
@property (weak, nonatomic) IBOutlet UILabel *action;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
