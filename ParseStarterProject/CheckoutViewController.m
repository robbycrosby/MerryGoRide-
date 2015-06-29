//
//  CheckoutViewController.m
//  ParseStarterProject
//
//  Created by Robert Crosby on 6/9/15.
//
//

#import "CheckoutViewController.h"

@interface CheckoutViewController ()

@property (nonatomic) BOOL applePaySucceeded;

@end

@implementation CheckoutViewController



- (void)viewDidLoad {
    totalcost = [NSNumber numberWithFloat:([_routecost floatValue] + 0.30)];
    _route.text = [NSString stringWithFormat:@"$%@",totalcost];
    [Tools roundbutton:_submit :9.0f];
    [super viewDidLoad];
    [Tools roundlabel:_route :9.0f];
    [Tools applyblur:_map :UIBlurEffectStyleDark];
    

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)submit:(id)sender {
    
    /*
    PFObject *gameScore = [PFObject objectWithClassName:@"Upcoming"];
    gameScore[@"username"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    gameScore[@"fromAddress"] = _start;
    gameScore[@"From"] = _start;
    gameScore[@"toAddress"] = _end;
    gameScore[@"To"] = _end;
    gameScore[@"Date"] = _dateofride;

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
   
    
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        request.countryCode = @"US";
        request.currencyCode = @"USD";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        request.merchantIdentifier = @"merchant.com.merrygoride-test";
       

        
        PKPaymentSummaryItem *ride = [PKPaymentSummaryItem summaryItemWithLabel:@"Ride Cost" amount:[NSDecimalNumber decimalNumberWithString:_routecost.stringValue]];
        NSNumber *feecost = @(0.30);
        PKPaymentSummaryItem *fee = [PKPaymentSummaryItem summaryItemWithLabel:@"Ride Fee" amount:[NSDecimalNumber decimalNumberWithString:feecost.stringValue]];
        NSNumber *sum = [NSNumber numberWithFloat:([_routecost floatValue] + [feecost floatValue])];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:sum.stringValue]];
        totalcost = sum;
        request.paymentSummaryItems = @[ride,fee,total];
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        [self presentViewController:paymentPane animated:TRUE completion:nil];
    }


}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"yo");
    [[STPAPIClient sharedClient] createTokenWithPayment:payment completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSLog(@"%@",error.description);
        } else {
            NSLog(@"%@",error.description);
            NSLog(@"%@",[NSString stringWithFormat:@"Tokens Successfully Created, %@",token]);
            [self createBackendChargeWithToken:token completion:completion];

        }
    }];
    }

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)createBackendChargeWithToken:(STPToken *)token
                          completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.119:5000/pay"];
    double cents = totalcost.doubleValue * 100;
    NSInteger finalcost = cents;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   // NSError *actualerror = [[NSError alloc] init];
    NSDictionary *tmp = @{
                                @"stripeToken" : token.tokenId,
                                @"amount" : @(finalcost + 1),
                                @"description" : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                                };
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   NSLog(@"💔");
                                   completion(PKPaymentAuthorizationStatusFailure);
                               } else {
                                   NSLog(@"❤️");
                                   completion(PKPaymentAuthorizationStatusSuccess);
                                   PFObject *gameScore = [PFObject objectWithClassName:@"Upcoming"];
                                   gameScore[@"username"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
                                   gameScore[@"fromAddress"] = _start;
                                   gameScore[@"From"] = _start;
                                   gameScore[@"toAddress"] = _end;
                                   gameScore[@"To"] = _end;
                                   gameScore[@"Date"] = _dateofride;
                                   gameScore[@"cost"] = totalcost;
                                   
                                   
                                   [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                       if (succeeded) {
                                           [RKDropdownAlert title:@"Ride Scheduled!" message:@"Please wait while we take you home."];
                                           [NSTimer scheduledTimerWithTimeInterval:2.5
                                                                            target:self
                                                                          selector:@selector(gohome)
                                                                          userInfo:nil
                                                                           repeats:NO];
                                           
                                       } else {
                                           // There was a problem, check error.description
                                       }
                                   }];

                               }
                           }];
}

-(void)gohome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UpcomingViewController *myVC = (UpcomingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Home"];
    myVC.isRefreshing = YES;
    [self presentViewController:myVC animated:YES completion:nil];
}

#define MAXLENGTH 16

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

- (IBAction)manual:(id)sender {
    manual = [[CustomIOSAlertView alloc] init];

    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    cardnumber = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
    [cardnumber setTextAlignment:NSTextAlignmentCenter];
    [cardnumber setDelegate:self];
    [cardnumber setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [cardnumber setPlaceholder:@"Credit Card Number"];
    [cardnumber setKeyboardType:UIKeyboardTypeNumberPad];
    expM = [[UITextField alloc] initWithFrame:CGRectMake(10, 55, 76, 30)];
    [expM setTextAlignment:NSTextAlignmentCenter];
    [expM setDelegate:self];
    [expM setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [expM setPlaceholder:@"7"];
    [expM setKeyboardType:UIKeyboardTypeNumberPad];
    expY = [[UITextField alloc] initWithFrame:CGRectMake(92, 55, 76, 30)];
    [expY setTextAlignment:NSTextAlignmentCenter];
    [expY setDelegate:self];
    [expY setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [expY setPlaceholder:@"19"];
    [expY setKeyboardType:UIKeyboardTypeNumberPad];
    cvc = [[UITextField alloc] initWithFrame:CGRectMake(174, 55, 76, 30)];
    [cvc setTextAlignment:NSTextAlignmentCenter];
    [cvc setDelegate:self];
    [cvc setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [cvc setPlaceholder:@"CVC"];
    [cvc setKeyboardType:UIKeyboardTypeNumberPad];
    [customView addSubview:cardnumber];
    [customView addSubview:expM];
    [customView addSubview:expY];
    [customView addSubview:cvc];
    [manual setContainerView:customView];
    [manual setDelegate:self];
    [manual setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Pay", nil]];
    [manual show];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [manual close];
    }
    
     else if (buttonIndex == 1) {
             card = [[STPCard alloc] init];
         NSLog(@"Card number: %@, Expiration Month: %@, Expiration Year: %@, CVC: %@",cardnumber.text,expM.text,expY.text,cvc.text);
             card.number = cardnumber.text;
             card.expMonth = expM.text;
             card.expYear = expY.text;
             card.cvc = cvc.text;
             [[STPAPIClient sharedClient] createTokenWithCard:card
                                                   completion:^(STPToken *token, NSError *error) {
                                                       if (error) {
                                                           NSLog(error.description);
                                                           [RKDropdownAlert title:@"Error Processing Card" message:@"Please verify all information is correct." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
                                                       } else {
                                                           NSURL *url = [NSURL URLWithString:@"http://192.168.0.119:5000/pay"];
                                                           double cents = totalcost.doubleValue * 100;
                                                           NSInteger finalcost = cents;
                                                           NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                                                           request.HTTPMethod = @"POST";
                                                           [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                                                           [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                                           // NSError *actualerror = [[NSError alloc] init];
                                                           NSDictionary *tmp = @{
                                                                                 @"stripeToken" : token.tokenId,
                                                                                 @"amount" : @(finalcost + 1),
                                                                                 @"description" : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                                                                                 };
                                                           NSError *error;
                                                           NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
                                                           [request setHTTPBody:postdata];
                                                           [NSURLConnection sendAsynchronousRequest:request
                                                                                              queue:[NSOperationQueue mainQueue]
                                                                                  completionHandler:^(NSURLResponse *response,
                                                                                                      NSData *data,
                                                                                                      NSError *error) {
                                                                                      if (error) {
                                                                                           [RKDropdownAlert title:@"Error Charging Card" message:@"Please try again later" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
                                                                                      } else {
                                                                                          NSLog(@"❤️");
                                                                                          PFObject *gameScore = [PFObject objectWithClassName:@"Upcoming"];
                                                                                          gameScore[@"username"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
                                                                                          gameScore[@"fromAddress"] = _start;
                                                                                          gameScore[@"From"] = _start;
                                                                                          gameScore[@"toAddress"] = _end;
                                                                                          gameScore[@"To"] = _end;
                                                                                          gameScore[@"Date"] = _dateofride;
                                                                                          gameScore[@"cost"] = totalcost;
                                                                                          
                                                                                          
                                                                                          [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                                              if (succeeded) {
                                                                                                  [RKDropdownAlert title:@"Ride Scheduled!" message:@"Please wait while we take you home."];
                                                                                                  [NSTimer scheduledTimerWithTimeInterval:2.5
                                                                                                                                   target:self
                                                                                                                                 selector:@selector(gohome)
                                                                                                                                 userInfo:nil
                                                                                                                                  repeats:NO];
                                                                                                  
                                                                                              } else {
                                                                                                  // There was a problem, check error.description
                                                                                              }
                                                                                          }];
                                                                                          
                                                                                      }
                                                                                  }];

                                                       }
                                                   }];
         
    }
}




@end

