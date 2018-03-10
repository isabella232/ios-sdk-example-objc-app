//
//  VibesAPI.h
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VibesPush;

@interface VibesAPIFRP : NSObject <VibesAPIDelegate>
- (nonnull RACSignal<RACTwoTuple<NSString *, NSError *> *> *)registerDevice;
- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)unregisterDevice;
- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)registerPush;
- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)unregisterPush;
- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)updateDeviceLocation:(NSNumber * _Nonnull )latitude
                                                                        longitude:(NSNumber * _Nonnull )longitude;
- (nonnull RACSignal<RACTwoTuple<MessageCollection *, NSError *> *> *)getInboxMessages;
@end
