//
//  ViewModel.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import "ViewModel.h"
#import "DemoConstant.h"

@interface ViewModel()
@property(nonatomic, readwrite, strong) id<VibesAPI> apiController;
@property(nonatomic, assign) BOOL registered;
@property(nonatomic, assign) BOOL registeredPush;
@end

@implementation ViewModel

- (instancetype)init:(id<VibesAPI>)apiController
{
    self = [super init];
    if (self) {
        _apiController = apiController;
        _registerDeviceButtonTitleSubject = [RACSubject subject];
        _registerPushButtonTitleSubject = [RACSubject subject];
        _registerPushButtonStateSubject = [RACSubject subject];
        _deviceIdValueSubject = [RACSubject subject];
        _registerTokenStateSubject = [RACSubject subject];
    }
    return self;
}

-(void)registerOrUnregisterDevice {
    if (!self.registered) {
        [self registerDevice];
    } else {
        [self unregisterDevice];
    }
}

-(void)registerOrUnregisterPush {
    if (!self.registeredPush) {
        [self registerPush];
    } else {
        [self unregisterPush];
    }
}

-(void)registerDevice {
    @weakify(self);
    [self.apiController registerDevice:^(NSString *deviceId, NSError *error) {
        @strongify(self);
        if (error == nil) {
            [self.registerDeviceButtonTitleSubject sendNext:@"UNREGISTER DEVICE"];
            [self.deviceIdValueSubject sendNext:deviceId];
            [self.registerPushButtonStateSubject sendNext:@YES];
            self.registered = YES;
        } else {
            // UI Show error
            NSLog(@"[REGISTER DEVICE] Error: %@", [error localizedDescription]);
        }
    }];
}

-(void)unregisterDevice {
    @weakify(self);
    [self.apiController unregisterDevice:^(NSError *error) {
        @strongify(self);
        if (error == nil) {
            [self.registerDeviceButtonTitleSubject sendNext:@"REGISTER DEVICE"];
            [self.deviceIdValueSubject sendNext:@"-"];
            [self.registerPushButtonStateSubject sendNext:@NO];
            [self.registerPushButtonTitleSubject sendNext:@"REGISTER PUSH"];
            [self.registerTokenStateSubject sendNext:@NO];
            self.registeredPush = NO;
            self.registered = NO;
        } else {
            // UI Show error
            NSLog(@"[UNREGISTER DEVICE] Error: %@", [error localizedDescription]);
        }
    }];
}

-(void)registerPush {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSData *token = (NSData *)[userdefault objectForKey:APNS_TOKEN];
    
    if (token != nil) {
        [[Vibes shared] setPushTokenFromData:token];
        @weakify(self);
        [self.apiController registerPush:^(NSError *error) {
            @strongify(self);
            if (error == nil) {
                [self.registerPushButtonTitleSubject sendNext:@"UNREGISTER PUSH"];
                [self.registerTokenStateSubject sendNext:@YES];
                self.registeredPush = YES;
            } else {
                // UI Show error
                NSLog(@"[REGISTER PUSH] Error: %@", [error localizedDescription]);
            }
        }];
    }
}

-(void)unregisterPush {
    @weakify(self);
    [self.apiController unregisterPush:^(NSError *error) {
        @strongify(self);
        if (error == nil) {
            [self.registerPushButtonTitleSubject sendNext:@"REGISTER PUSH"];
            [self.registerTokenStateSubject sendNext:@NO];
            self.registeredPush = NO;
        } else {
            // UI Show error
            NSLog(@"[UNREGISTER PUSH] Error: %@", [error localizedDescription]);
        }
    }];
}

-(void)updateLocationWith:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    [self.apiController updateLocation:latitude longitude:longitude completionHandler:^(NSError *error) {
        if (error == nil) {
            NSLog(@"[UPDATE LOCATION] SUCCESS");
        } else {
            // UI Show error
            NSLog(@"[UPDATE LOCATION] Error: %@", [error localizedDescription]);
        }
    }];
}

@end
