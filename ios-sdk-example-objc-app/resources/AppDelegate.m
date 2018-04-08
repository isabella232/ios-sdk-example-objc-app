//
//  AppDelegate.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 2/28/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
@import VibesPush;

@interface AppDelegate ()
@property(nonatomic, strong) ViewController *vController;
@property(nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

NSString * const kClientDataKey = @"client_app_data";
NSString * const kClientCustomDataKey = @"client_custom_data";
NSString * const kDeepLink = @"deep_link";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (SYSTEM_VERSION_LESS_THAN( @"10.0")) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        #pragma clang diagnostic pop
        
    } else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
             if(!error && granted) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[UIApplication sharedApplication] registerForRemoteNotifications];
                 });
             } else {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
    
    // Vibes configuration
    [Vibes configureWithAppId:@"[YOUR APP ID HERE]"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.vController = [ViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.vController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:deviceToken forKey:APNS_TOKEN];
    [userdefault synchronize];
    // Here, you may register push, or if the push registration depends on the user being logged in or not, you can
    // add the logic here
    // If the user is logged in then ...
    // [[Vibes shared] setPushTokenFromData:deviceToken];
    // [[Vibes shared] registerPush];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self receivedPushNotifWith:userInfo];
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [self receivedPushNotifWith:response.notification.request.content.userInfo];
    completionHandler();
}

- (void)receivedPushNotifWith:(NSDictionary *)userInfo {
    [Vibes configureWithAppId:@"[YOUR APP ID HERE]"];
    [[Vibes shared] receivedPushWith:userInfo at:[NSDate date]];
    if (userInfo[kClientCustomDataKey]) {
        // Do something with the custom data
    }
    if (userInfo[kClientDataKey][kDeepLink]) {
        // Do something with the deep_link: load a viewcontroller...
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // According your app logic, you may unregister here
    // [[Vibes shared] unregisterPush];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

