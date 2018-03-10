//
//  VibesLabel.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import "VibesLabel.h"
#import "UIColor+Demo.h"

@implementation VibesLabel

- (instancetype)initWithTitle:(NSString *)title font:(UIFont  * _Nullable )font color:(UIColor * _Nullable)color {
    self = [super initWithFrame:CGRectNull];
    if (self != nil){
        self.text = title;
        
        if (color == nil) {
            self.textColor = [UIColor vibesTitleLabel];
        } else {
            self.textColor = color;
        }
        
        if (font == nil) {
            self.font = [UIFont systemFontOfSize:17];
        } else {
            self.font = font;
        }
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

@end
