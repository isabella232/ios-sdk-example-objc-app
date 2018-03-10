//
//  VibesAPI.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//
@import ReactiveObjC;
#import "VibesAPIFRP.h"

@implementation VibesAPIFRP

/**
 * WARNING!
 * The following is an example how to wrap VibesAPI calls with ReactiveObjc.
 * It's currently not used. `ViewController` uses the class `VibesAPIBlock` instead.
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[Vibes shared] setWithDelegate:self];
    }
    return self;
}

- (nonnull RACSignal<RACTwoTuple<NSString *, NSError *> *> *)registerDevice {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[self rac_signalForSelector:@selector(didRegisterDeviceWithDeviceId:error:)
                                                    fromProtocol:@protocol(VibesAPIDelegate)] subscribe:subscriber];
        [[Vibes shared] registerDevice];
        return disposable;
    }];
}

- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)unregisterDevice {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[[self rac_signalForSelector:@selector(didUnregisterDeviceWithError:)
                                                     fromProtocol:@protocol(VibesAPIDelegate)]
                                      map:^RACTwoTuple<NSNumber *, NSError *>* _Nullable(RACTuple * _Nullable arguments) {
                                          BOOL existingError = (((NSError *)arguments.first) == nil);
                                          return RACTuplePack([NSNumber numberWithBool:existingError], arguments.first);
                                      }]
                                     subscribe:subscriber];
        
        [[Vibes shared] unregisterDevice];
        return disposable;
    }];
}

- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)registerPush {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[[self rac_signalForSelector:@selector(didRegisterPushWithError:)
                                                     fromProtocol:@protocol(VibesAPIDelegate)]
                                      map:^RACTwoTuple<NSNumber *, NSError *>* _Nullable(RACTuple * _Nullable arguments) {
                                          BOOL existingError = (((NSError *)arguments.first) == nil);
                                          return RACTuplePack([NSNumber numberWithBool:existingError], arguments.first);
                                      }]
                                     subscribe:subscriber];
        
        [[Vibes shared] registerPush];
        return disposable;
    }];
}

- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)unregisterPush {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[[self rac_signalForSelector:@selector(didUnregisterPushWithError:)
                                                     fromProtocol:@protocol(VibesAPIDelegate)]
                                      map:^RACTwoTuple<NSNumber *, NSError *>* _Nullable(RACTuple * _Nullable arguments) {
                                          BOOL existingError = (((NSError *)arguments.first) == nil);
                                          return RACTuplePack([NSNumber numberWithBool:existingError], arguments.first);
                                      }]
                                     subscribe:subscriber];
        
        [[Vibes shared] unregisterPush];
        return disposable;
    }];
}

- (nonnull RACSignal<RACTwoTuple<NSNumber *, NSError *> *> *)updateDeviceLocation:(NSNumber *)latitude
                                                                        longitude:(NSNumber *)longitude {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[[self rac_signalForSelector:@selector(didUpdateDeviceLocationWithError:)
                                                     fromProtocol:@protocol(VibesAPIDelegate)]
                                      map:^RACTwoTuple<NSNumber *, NSError *>* _Nullable(RACTuple * _Nullable arguments) {
                                          BOOL existingError = (((NSError *)arguments.first) == nil);
                                          return RACTuplePack([NSNumber numberWithBool:existingError], arguments.first);
                                      }]
                                     subscribe:subscriber];
        
        [[Vibes shared] updateDeviceWithLat:latitude.doubleValue long:longitude.doubleValue];
        return disposable;
    }];
}

- (nonnull RACSignal<RACTwoTuple<MessageCollection *, NSError *> *> *)getInboxMessages {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self);
        RACDisposable *disposable = [[self rac_signalForSelector:@selector(didUpdateDeviceLocationWithError:)
                                                     fromProtocol:@protocol(VibesAPIDelegate)] subscribe:subscriber];
        
        [[Vibes shared] getInboxMessages];
        return disposable;
    }];
}

#pragma mark VibesPush delegate
- (void)didRegisterDeviceWithDeviceId:(NSString *)deviceId error:(NSError *)error {}
- (void)didUnregisterDeviceWithError:(NSError *)error {}
- (void)didRegisterPushWithError:(NSError *)error {}
- (void)didUnregisterPushWithError:(NSError *)error {}
- (void)didUpdateDeviceLocationWithError:(NSError *)error {}
- (void)didGetInboxMessagesWithMessages:(MessageCollection *)messages error:(NSError *)error {}

@end
