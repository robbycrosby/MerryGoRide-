//
//  CheckoutViewController.h
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/9/15.
//
//

#import "ParseStarterProjectAppDelegate.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Tools.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RKDropdownAlert.h"
#import <PassKit/PassKit.h>
#import <Stripe+ApplePay.h>
#import <Stripe.h>
#import "STPAPIClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "UpcomingViewController.h"
#import "CustomIOSAlertView.h"
#import "STPCard.h"



@interface CheckoutViewController : UIViewController  <PKPaymentAuthorizationViewControllerDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate> {
    NSInteger ridersint;
    UIDatePicker *dateselect;
    NSDate *pdate;
    NSString *StripePublishableKey,*BackendChargeURLString,*AppleMerchantId;
    PKPaymentAuthorizationViewController *paymentView;
    NSNumber *totalcost;
    CustomIOSAlertView *manual;
    UITextField *cardnumber,*expM,*expY,*cvc;
    NSString *cardnum,*cardm,*cardy,*cardcvc;
    STPCard *card;
}

@property (weak, nonatomic) IBOutlet UILabel *route;
@property (nonatomic) NSDate *dateofride;
@property (nonatomic) NSNumber *routecost;
@property (nonatomic) NSInteger passengers;
@property (nonatomic) NSString *start;
@property (nonatomic) NSString *end;
@property (nonatomic) NSString *startshortname;
@property (nonatomic) NSString *endshortname;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submit;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *map;
- (IBAction)manual:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *manual;



@end
