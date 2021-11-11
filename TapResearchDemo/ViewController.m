//
//  ViewController.m
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <TapResearchSDK/TapResearchSDK.h>


@interface ViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *surveyButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.surveyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.surveyButton.frame = CGRectMake(100, 170, 200, 30);
    self.surveyButton.layer.cornerRadius = 10;
    self.surveyButton.backgroundColor = UIColor.blueColor;
    [self.surveyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.surveyButton setTitle:@"Survey Available!" forState:UIControlStateNormal];
    self.surveyButton.alpha = 0.0;
    [self.view addSubview:self.surveyButton];
    
    [self.surveyButton addTarget:self action:@selector(showSurvey) forControlEvents:UIControlEventTouchUpInside];
    self.surveyButton.center = self.view.center;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
    
    [self initSDK];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.activityIndicator = nil;
}

- (void)showSurveyAvailableButton {
    dispatch_async( dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SurveyAvailableNotification" object:nil];
        [self.activityIndicator stopAnimating];
        self.surveyButton.alpha = 0.0;
        [UIView animateWithDuration:0.75 animations:^{self.surveyButton.alpha = 1.0;}];
    });
}

- (void)showSurvey {
    if (self.tapresearchPlacement.isSurveyWallAvailable) {
        NSLog(@"Placement: %@:", self.tapresearchPlacement.placementIdentifier);
        [self.tapresearchPlacement showSurveyWallWithDelegate:self];
    }
    else {
        NSLog(@"Placement %@ isn't available", self.tapresearchPlacement.placementIdentifier);
    }
}

//You must init the sdk with your own api token and uniqueIdentifier
- (void)initSDK {
    [TapResearch initWithApiToken: @"7d08c962b40ac7aa0cf83c4d376fa36f" rewardDelegate:self placementDelegate:self];
    [TapResearch setUniqueUserIdentifier:@"Nascar"];
}

- (void)showNotificationDialogwith:(NSString *)title message:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - TapResearch Delegates

//When the TapResearch webview is dismissed, this delegate is called if there is a reward present
- (void)tapResearchDidReceiveRewards:(nonnull NSArray<TRReward *> *)rewards {
    NSLog(@"Reward Received!");
    NSString *title = @"Congrats!";
    NSString *message = [NSString stringWithFormat:@"You have just received %lu %@ for your efforts.", (long)rewards.firstObject.rewardAmount, rewards.firstObject.currencyName];
    [self showNotificationDialogwith:title message:message];
}

//This delegate is called after the SDK is initialized and placements are ready
- (void)placementReady:(nonnull TRPlacement *)placement {
    NSLog(@"✅ placement ready");
    
    if (!self.tapresearchPlacement) {
        self.tapresearchPlacement = placement;
        if (placement.isSurveyWallAvailable && placement.placementCode != PLACEMENT_CODE_SDK_NOT_READY) {
            [self showSurveyAvailableButton];
        }
    }
}

- (void)placementUnavailable:(nonnull NSString *)placementId {
    NSLog(@"Placement Unavailable");
}

#pragma mark - TapResearchSurveyDelegate

- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement; {
    NSLog(@"Survey wall opened");
}

- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement; {
    NSLog(@"Survey wall dismissed");
    self.tapresearchPlacement = nil;
}

@end
