//
//  VibesAPI.h
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//
@import VibesPush;

@protocol VibesAPI
typedef void (^VibesAPIRegisterDeviceBlock)(NSString *deviceId, NSError *error);
typedef void (^VibesAPICompletionBlock)(NSError *error);
typedef void (^VibesAPIInboxMessageBlock)(MessageCollection *messageRepository, NSError *error);

- (void)registerDevice:(VibesAPIRegisterDeviceBlock)completionHandler;
- (void)unregisterDevice:(VibesAPICompletionBlock)completionHandler;
- (void)registerPush:(VibesAPICompletionBlock)completionHandler;
- (void)unregisterPush:(VibesAPICompletionBlock)completionHandler;
- (void)updateLocation:(NSNumber *)latitude longitude:(NSNumber *)longitude
     completionHandler:(VibesAPICompletionBlock)completionHandler;
- (void)getInboxMessages:(VibesAPIInboxMessageBlock)completionHandler;
@end
