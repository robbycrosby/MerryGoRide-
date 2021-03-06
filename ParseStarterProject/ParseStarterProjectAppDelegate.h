//
//  ParseStarterProjectAppDelegate.h
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stripe.h"

@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;

@end
