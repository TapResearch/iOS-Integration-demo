//
//  ViewController.m
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import "ViewController.h"
#import <TapResearchSDK/TapResearchSDK.h>
#import "AppDelegate.h"


@interface ViewController ()<TapResearchPlacementDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *surveyButton;
@property (nonatomic, strong) NSMutableDictionary *placements;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.surveyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.surveyButton.frame = CGRectMake(100, 170, 100, 30);
    self.surveyButton.layer.cornerRadius = 10;
    self.surveyButton.backgroundColor = UIColor.blueColor;
    [self.surveyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.surveyButton setTitle:@"Survey" forState:UIControlStateNormal];
    
    [self.surveyButton addTarget:self action:@selector(handleSurveySelected) forControlEvents:UIControlEventTouchUpInside];
    self.surveyButton.center = self.view.center;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self initTapResearchPlacement];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SurveyAvailableNotification" object:nil];
    self.activityIndicator = nil;
}

- (void)initTapResearchPlacement
{
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [TapResearch initWithApiToken:@"API_TOKEN" rewardDelegate:del placementDelegate:self];
    [TapResearch setUniqueUserIdentifier:@"<User Identifier>"];
}

- (void)showSurveyAvailable
{
    [self.activityIndicator stopAnimating];
    
    self.surveyButton.alpha = 0.0;
    [self.view addSubview:self.surveyButton];
    [UIView animateWithDuration:0.75 animations:^{self.surveyButton.alpha = 1.0;}];
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
    [self initTapResearchPlacement];
}

#pragma mark - TapResearchPlacementDelegate

- (void)placementReady:(nonnull TRPlacement *)placement {
    NSLog(@"PLACEMENT READY! %@, wall %d, hot %d, maxlen %ld, plcode %ld", placement.placementIdentifier, placement.isSurveyWallAvailable, placement.hasHotSurvey, placement.maxSurveyLength, placement.placementCode);

    [self.placements setObject:placement forKey:placement.placementIdentifier];
}


- (void)placementUnavailable:(nonnull NSString *)placementId {
    NSLog(@"PLACEMENT UNAVAILABLE! %@", placementId);

    [self.placements removeObjectForKey:placementId];
}

@end
