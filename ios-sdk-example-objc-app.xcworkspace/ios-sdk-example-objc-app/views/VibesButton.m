//
//  VibesButton.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 3/7/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#import "VibesButton.h"
#import "UIColor+Demo.h"
@implementation VibesButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor vibesButtonColor]];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.layer.borderColor = [[UIColor vibesButtonColor] CGColor];
        [[self titleLabel] setTextColor:[UIColor whiteColor]];
        [[self titleLabel] setFont:[UIFont systemFontOfSize:17]];
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 1;
    }
    return self;
}

@end
