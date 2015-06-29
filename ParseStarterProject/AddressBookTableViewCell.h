//
//  AddressBookTableViewCell.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/18/15.
//
//

#import <UIKit/UIKit.h>

@interface AddressBookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
