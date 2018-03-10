//
//  VibesAPIBlock.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import "VibesAPIBlock.h"

@implementation VibesAPIBlock

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[Vibes shared] addWithObserver:self];
    }
    return self;
}
- (void)registerDevice:(VibesAPIRegisterDeviceBlock)completionHandler {
    self.registerDeviceCallback = completionHandler;
    [[Vibes shared] registerDevice];
}

- (void)unregisterDevice:(VibesAPICompletionBlock)completionHandler {
    self.unregisterDeviceCallback = completionHandler;
    [[Vibes shared] unregisterDevice];
}

- (void)registerPush:(VibesAPICompletionBlock)completionHandler {
    self.registerPushCallback = completionHandler;
    [[Vibes shared] registerPush];
}

- (void)unregisterPush:(VibesAPICompletionBlock)completionHandler {
    self.unregisterPushCallback = completionHandler;
    [[Vibes shared] unregisterPush];
}

- (void)updateLocation:(NSNumber *)latitude longitude:(NSNumber *)longitude
     completionHandler:(VibesAPICompletionBlock)completionHandler {
    self.updateLocationCallback = completionHandler;
    [[Vibes shared] updateDeviceWithLat:latitude.doubleValue long:longitude.doubleValue];
}

- (void)getInboxMessages:(VibesAPIInboxMessageBlock)completionHandler {
    self.messagesInboxCallback = completionHandler;
    [[Vibes shared] getInboxMessages];
}

#pragma mark VibesPush delegate

- (void)didRegisterDeviceWithDeviceId:(NSString *)deviceId error:(NSError *)error {
    if (self.registerDeviceCallback != nil) {
        self.registerDeviceCallback(deviceId, error);
    }
}

- (void)didUnregisterDeviceWithError:(NSError *)error {
    if (self.unregisterDeviceCallback != nil) {
        self.unregisterDeviceCallback(error);
    }
}

- (void)didRegisterPushWithError:(NSError *)error {
    if (self.registerPushCallback != nil) {
        self.registerPushCallback(error);
    }
}

- (void)didUnregisterPushWithError:(NSError *)error {
    if (self.unregisterPushCallback != nil) {
        self.unregisterPushCallback(error);
    }
}

- (void)didUpdateDeviceLocationWithError:(NSError *)error {
    if (self.updateLocationCallback != nil) {
        self.updateLocationCallback(error);
    }
}

- (void)didGetInboxMessagesWithMessages:(MessageCollection *)messages error:(NSError *)error {
    if (self.messagesInboxCallback != nil) {
        self.messagesInboxCallback(messages, error);
    }
}

@end
