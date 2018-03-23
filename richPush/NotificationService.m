//
//  NotificationService.m
//  richPush
//
//  Created by Jean-Michel Barbieri on 3/22/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService
// Constants
NSString * const kClientDataKey = @"client_app_data";
NSString * const kImageUrlKey = @"image_url";
NSString * const kVideoUrlKey = @"video_url";
NSString * const kRichContentIdentifier = @"richContent";

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString *imageURL = self.bestAttemptContent.userInfo[kClientDataKey][kImageUrlKey];
    NSString *videoURL = self.bestAttemptContent.userInfo[kClientDataKey][kVideoUrlKey];
    
    NSURL *attachmentURL = nil;
    if (imageURL.length > 0) { // Check if imageURL is nil or empty
        attachmentURL = [NSURL URLWithString:imageURL];
    } else if (videoURL.length > 0) { // Check if videoURL is nil or empty
        attachmentURL = [NSURL URLWithString:videoURL];
    } else {
        // Nothing to download
        return;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *downloadTask = [session downloadTaskWithURL:attachmentURL completionHandler:^(NSURL *fileLocation, __unused NSURLResponse *response, NSError *error) {
        if (error == nil && fileLocation != nil) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *fileSuffix = attachmentURL.lastPathComponent;
            
            NSURL *typedAttachmentURL = [NSURL fileURLWithPath:[(NSString *_Nonnull)fileLocation.path stringByAppendingString:fileSuffix]];
            [fileManager moveItemAtURL:fileLocation toURL:typedAttachmentURL error:&error];
            
            NSError *attachError = nil;
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:kRichContentIdentifier URL:typedAttachmentURL options:nil error:&attachError];
            
            if (attachment != nil && attachError == nil) {
                UNMutableNotificationContent *modifiedContent = self.bestAttemptContent.mutableCopy;
                [modifiedContent setAttachments:[NSArray arrayWithObject:attachment]];
                self.contentHandler(modifiedContent);
            }
        }
    }];
    
    [downloadTask resume];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
