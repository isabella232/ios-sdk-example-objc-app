//
//  ViewModel.h
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//
@import ReactiveObjC;
#import <Foundation/Foundation.h>
#import "VibesAPI.h"

@interface ViewModel : NSObject
@property(nonatomic, readonly, strong) RACSubject<NSString *> *registerDeviceButtonTitleSubject;
@property(nonatomic, readonly, strong) RACSubject<NSString *> *deviceIdValueSubject;
@property(nonatomic, readonly, strong) RACSubject<NSString *> *registerPushButtonTitleSubject;
@property(nonatomic, readonly, strong) RACSubject<NSNumber *> *registerPushButtonStateSubject;
@property(nonatomic, readonly, strong) RACSubject<NSNumber *> *registerTokenStateSubject;
-(void)registerOrUnregisterDevice;
-(void)registerOrUnregisterPush;
-(void)updateLocationWith:(NSNumber *)latitude longitude:(NSNumber *)longitude;
- (instancetype)init:(id<VibesAPI>)apiController;
@end
