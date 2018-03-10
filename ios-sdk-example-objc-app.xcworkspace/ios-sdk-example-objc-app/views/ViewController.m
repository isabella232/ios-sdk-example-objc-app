//
//  ViewController.m
//  ios-sdk-example-objc-app
//
//  Created by Jean-Michel Barbieri on 2/28/18.
//  Copyright © 2018 Jean-Michel Barbieri. All rights reserved.
//

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@import ReactiveObjC;
#import "ViewController.h"
#import "DemoConstant.h"
#import "ViewModel.h"
#import "VibesAPIBlock.h"
#import "VibesButton.h"
#import "VibesLabel.h"
#import "UIColor+Demo.h"

@import VibesPush;

@interface ViewController () <VibesAPIDelegate>
//@property(nonatomic, assign) BOOL registered;
@property(nonatomic, assign) BOOL registeredPush;
@property(nonatomic, strong) ViewModel *viewModel;
@property(nonatomic, weak) UIButton *registerButton;
@property(nonatomic, weak) UIButton *registerPush;
@property(nonatomic, weak) UIButton *updateLocation;
@property(nonatomic, weak) UIButton *getInboxMsgs;
@property(nonatomic, weak) UILabel *deviceIdTitle;
@property(nonatomic, weak) UILabel *deviceIdValue;
@property(nonatomic, weak) UILabel *registerPushTitle;
@property(nonatomic, weak) UILabel *registerPushValue;
@property(nonatomic, weak) UILabel *pushTokenValue;
@property(nonatomic, weak) UIImageView *background;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.viewModel = [[ViewModel alloc] init:[VibesAPIBlock new]];

    UIButton *registerButton = [VibesButton new];
    UIButton *registerPush = [VibesButton new];
    UIButton *updateLocation = [VibesButton new];
    
    UILabel *deviceIdTitle = [[VibesLabel alloc] initWithTitle:@"Vibes Device ID" font:nil color:nil];
    UILabel *deviceIdValue = [[VibesLabel alloc] initWithTitle:@"" font:[UIFont systemFontOfSize:15]
                                                         color:[UIColor vibesValueLabel]];
    UILabel *registerPushTitle = [[VibesLabel alloc] initWithTitle:@"Apple Push Token" font:nil color:nil];
    UILabel *registerPushValue = [[VibesLabel alloc] initWithTitle:@"" font:nil color:nil];
    UILabel *pushTokenValue = [[VibesLabel alloc] initWithTitle:@"-" font:[UIFont systemFontOfSize:10] color:[UIColor vibesValueLabel]];
    
    if (SCREEN_WIDTH < 750) {
        deviceIdValue.font = [UIFont systemFontOfSize:12];
        pushTokenValue.font = [UIFont systemFontOfSize:8];
        registerPushValue.font = [UIFont systemFontOfSize:12];
    }
    
    pushTokenValue.numberOfLines = 0;
    pushTokenValue.lineBreakMode = NSLineBreakByCharWrapping;
    
    UIImageView *background = [UIImageView new];
    
    if (SCREEN_HEIGHT > 1136) {
        [background setImage:[UIImage imageNamed:@"background"]];
        [background setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    [updateLocation setTitle:@"UPDATE LOC." forState:UIControlStateNormal];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSData *token = (NSData *)[userdefault objectForKey:APNS_TOKEN];
    NSString *deviceTokenString = [[[[token description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    pushTokenValue.text = deviceTokenString;
    
    self.registerButton = registerButton;
    self.registerPush = registerPush;
    self.updateLocation = updateLocation;
    self.deviceIdTitle = deviceIdTitle;
    self.deviceIdValue = deviceIdValue;
    self.registerPushTitle = registerPushTitle;
    self.registerPushValue = registerPushValue;
    self.pushTokenValue = pushTokenValue;
    self.background = background;
    
    [self.view addSubview:registerButton];
    [self.view addSubview:registerPush];
    [self.view addSubview:updateLocation];
    [self.view addSubview:deviceIdTitle];
    [self.view addSubview:deviceIdValue];
    [self.view addSubview:registerPushTitle];
    [self.view addSubview:registerPushValue];
    [self.view addSubview:pushTokenValue];
    [self.view addSubview:background];
    
    [self setupConstraints];
    [self setupObservers];
}

- (void)setupObservers {
    // Buttons Actions
    UIButton *registerButton = self.registerButton;
    @weakify(self);
    [[registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id __unused _) {
         @strongify(self);
         [self.viewModel registerOrUnregisterDevice];
     }];
    
    UIButton *registerPushButton = self.registerPush;
    [[registerPushButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id __unused _) {
         @strongify(self);
         [self.viewModel registerOrUnregisterPush];
     }];
    
    UIButton *updateLocationButton = self.updateLocation;
    [[updateLocationButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id __unused _) {
         @strongify(self);
         [self.viewModel updateLocationWith:@48.866667 longitude:@2.333333];
     }];
    // End Buttons Actions
    
    [[[self.viewModel.registerDeviceButtonTitleSubject
        startWith:@"REGISTER DEVICE"]
        deliverOnMainThread]
        subscribeNext:^(NSString * _Nullable title) {
            @strongify(self);
            [self.registerButton setTitle:title forState:UIControlStateNormal];
        }];
    
    [[[self.viewModel.registerPushButtonTitleSubject
        startWith:@"REGISTER PUSH"]
        deliverOnMainThread]
        subscribeNext:^(NSString * _Nullable title) {
            @strongify(self);
            [self.registerPush setTitle:title forState:UIControlStateNormal];
        }];
    
    [[self.viewModel.deviceIdValueSubject deliverOnMainThread]
     subscribeNext:^(NSString * _Nullable value) {
         @strongify(self);
         [self.deviceIdValue setText:value];
     }];
    
    [[[self.viewModel.registerPushButtonStateSubject
        startWith:@NO]
        deliverOnMainThread]
        subscribeNext:^(NSNumber * _Nullable enabled) {
            @strongify(self);
            [self.registerPush setEnabled:enabled];
            [self.updateLocation setEnabled:enabled];
            if (enabled.boolValue) {
                [self.registerPush setBackgroundColor:[UIColor vibesButtonColor]];
                self.registerPush.layer.borderColor = [UIColor vibesButtonColor].CGColor;
                [self.updateLocation setBackgroundColor:[UIColor vibesButtonColor]];
                self.updateLocation.layer.borderColor = [UIColor vibesButtonColor].CGColor;
            } else {
                [self.registerPush setBackgroundColor:[UIColor vibesValueLabel]];
                self.registerPush.layer.borderColor = [UIColor vibesValueLabel].CGColor;
                [self.updateLocation setBackgroundColor:[UIColor vibesValueLabel]];
                self.updateLocation.layer.borderColor = [UIColor vibesValueLabel].CGColor;
            }
        }];
    
    [[[self.viewModel.registerTokenStateSubject
        startWith:@NO]
        deliverOnMainThread]
        subscribeNext:^(NSNumber * _Nullable tokenRegistered) {
            @strongify(self);
            if (tokenRegistered.boolValue) {
                self.registerPushValue.text = @"[REGISTERED]";
                self.registerPushValue.textColor = [UIColor greenColor];
            } else {
                self.registerPushValue.text = @"[NOT REGISTERED]";
                self.registerPushValue.textColor = [UIColor redColor];
            }
        }];
}

- (void)setupConstraints {
    UILabel *deviceIdTitle = self.deviceIdTitle;
    [deviceIdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset = 20;
        make.top.equalTo(self.view).offset = 100;
    }];
    
    UILabel *deviceIdValue = self.deviceIdValue;
    [deviceIdValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceIdTitle);
        make.top.equalTo(deviceIdTitle.mas_bottom).offset = 10;
    }];
    
    UILabel *registerPushTitle = self.registerPushTitle;
    [registerPushTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceIdTitle);
        make.top.equalTo(deviceIdValue).offset = 40;
    }];
    
    UILabel *registerPushValue = self.registerPushValue;
    [registerPushValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerPushTitle.mas_right).offset = 10;
        make.top.equalTo(registerPushTitle);
    }];
    
    UILabel *pushTokenValue = self.pushTokenValue;
    [pushTokenValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deviceIdTitle);
        make.top.equalTo(registerPushTitle.mas_bottom).offset = 20;
    }];
    
    UIImageView *background = self.background;
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset = -50;
    }];
    
    UIButton *registerButton = self.registerButton;
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset = -40;
        make.height.equalTo(@60);
        make.top.equalTo(self.pushTokenValue).offset = 40;
    }];
    
    UIButton *registerPushButton = self.registerPush;
    [registerPushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerButton.mas_left);
        make.right.equalTo(registerButton.mas_right);
        make.height.equalTo(@60);
        make.top.equalTo(registerButton.mas_bottom).offset = 20;
    }];
    
    UIButton *updateLocationButton = self.updateLocation;
    [updateLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerButton.mas_left);
        make.right.equalTo(registerButton.mas_right);
        make.height.equalTo(@60);
        make.top.equalTo(registerPushButton.mas_bottom).offset = 20;
    }];
}

@end
