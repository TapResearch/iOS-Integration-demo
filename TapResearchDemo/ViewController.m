//
//  ViewController.m
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import "ViewController.h"
#import <TapResearchSDK/TapResearchSDK.h>

@interface ViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *surveyButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.surveyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.surveyButton.frame = CGRectMake(100, 170, 100, 30);
    self.surveyButton.layer.cornerRadius = 10;
    self.surveyButton.backgroundColor = UIColor.blueColor;
    self.surveyButton.center = self.view.center;
    [self.surveyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.surveyButton setTitle:@"Survey" forState:UIControlStateNormal];
    [self.surveyButton addTarget:self action:@selector(handleSurveySelected) forControlEvents:UIControlEventTouchUpInside];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];

    [self initTapResearchPlacement];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTapResearchPlacement:)
                                                 name:UIApplicationDidBecomeActiveNotification//UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)refreshTapResearchPlacement:(NSNotification*)notification
{
    /* If we have a placement already we need to refresh that if the app is brought into foreground. */
    if (self.tapresearchPlacement) {
        self.surveyButton.alpha = 0.0;
        [self.activityIndicator startAnimating];
        [self initTapResearchPlacement];
    }
}

- (void)initTapResearchPlacement
{
    [TapResearch initPlacementWithIdentifier:@"PLACEMENT_IDENTIFIER" placementBlock:^(TRPlacement *placement) {
        self.tapresearchPlacement = placement;
        if (placement.isSurveyWallAvailable && placement.placementCode != PLACEMENT_CODE_SDK_NOT_READY) {
            [self showSurveyAvailable];
        }
    }];
}

- (void)showSurveyAvailable
{
    [self.activityIndicator stopAnimating];
    [self.view addSubview:self.surveyButton];
    [UIView animateWithDuration:0.5
                     animations:^{
        self.surveyButton.alpha = 1.0;
    }
     ];
}

- (void)handleSurveySelected
{
    if (self.tapresearchPlacement) {
        [self.tapresearchPlacement showSurveyWallWithDelegate:self];
    }
}

#pragma mark - TapResearchSurveyDelegate

- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement;
{
    NSLog(@"Survey wall opened");
}

- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement;
{
    NSLog(@"Survey wall dismissed");
    /*TRPlacemnt will be disabled after the survey wall was visible.
     If you want to show the placement again you'll have to initialize it again
     */
    self.surveyButton.alpha = 0.0;
    [self.activityIndicator startAnimating];
    [self initTapResearchPlacement];
}

@end
