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
    self.surveyButton.frame = CGRectMake(100, 170, 200, 50);
    self.surveyButton.layer.cornerRadius = 10;
    self.surveyButton.backgroundColor = UIColor.systemBlueColor;
    [self.surveyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.surveyButton setTitle:@"Tap to take survey" forState:UIControlStateNormal];
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

// present survey wall when surveys are available
- (void)showSurvey {
    NSLog(@"Placement: %@:", self.tapresearchPlacement.placementIdentifier);
    [self.tapresearchPlacement showSurveyWallWithDelegate:self];
}

//SDK must be initialized with an api token and uniqueIdentifier
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

// When the TapResearch modal is dismissed, this method is called with an array of TRReward to be used within your app
- (void)tapResearchDidReceiveRewards:(nonnull NSArray<TRReward *> *)rewards {
    NSLog(@"Reward Received!");
    NSString *title = @"Congrats!";
    NSString *message = [NSString stringWithFormat:@"You have just received %lu %@ for your efforts.", (long)rewards.firstObject.rewardAmount, rewards.firstObject.currencyName];
    [self showNotificationDialogwith:title message:message];
}

// After the SDK is initialized, this delegate is called for each placement
- (void)placementReady:(nonnull TRPlacement *)placement {
    NSLog(@"✅ placement ready");
    
    if (!self.tapresearchPlacement) {
        self.tapresearchPlacement = placement;
        if (placement.isSurveyWallAvailable && placement.placementCode != PLACEMENT_CODE_SDK_NOT_READY) {
            [self showSurveyAvailableButton];
        }
    }
}

// If the placement is not available for any reason, this delegate is called
- (void)placementUnavailable:(nonnull NSString *)placementId {
    NSLog(@"Placement Unavailable");
}

#pragma mark - TapResearchSurveyDelegate

// This delegate is called when the survey wall is opened
- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement; {
    NSLog(@"Survey wall opened");
}

// This delegate is called when the survey wall is dismissed
- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement; {
    NSLog(@"Survey wall dismissed");
    self.tapresearchPlacement = nil;
}

@end
