//
//  AppDelegate.h
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 2/28/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "DemoConstant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

