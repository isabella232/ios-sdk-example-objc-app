//
//  VibesAPIBlock.h
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VibesAPI.h"

@interface VibesAPIBlock : NSObject<VibesAPI, VibesAPIDelegate>
@property (readwrite, nonatomic, copy) VibesAPIRegisterDeviceBlock registerDeviceCallback;
@property (readwrite, nonatomic, copy) VibesAPICompletionBlock unregisterDeviceCallback;
@property (readwrite, nonatomic, copy) VibesAPICompletionBlock registerPushCallback;
@property (readwrite, nonatomic, copy) VibesAPICompletionBlock unregisterPushCallback;
@property (readwrite, nonatomic, copy) VibesAPICompletionBlock updateLocationCallback;
@property (readwrite, nonatomic, copy) VibesAPIInboxMessageBlock messagesInboxCallback;
@end
