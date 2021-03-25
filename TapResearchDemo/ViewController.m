//
//  ViewController.m
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import "ViewController.h"
#import <TapResearchSDK/TapResearchSDK.h>

#define TRPlacementIdentifier @"PLACEMENT_IDENTIFIER"

@interface ViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *surveyButton;
@property (nonatomic, strong) UIButton *reInitButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.reInitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.reInitButton.frame = CGRectMake(0, 0, 200, 30);
    self.reInitButton.layer.cornerRadius = 10;
    self.reInitButton.backgroundColor = UIColor.blueColor;
    self.reInitButton.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.reInitButton.alpha = 0.0;
    [self.reInitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.reInitButton setTitle:@"Initialize Placement" forState:UIControlStateNormal];
    [self.reInitButton addTarget:self action:@selector(handleReInitSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reInitButton];

    self.surveyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.surveyButton.frame = CGRectMake(0, 0, 100, 30);
    self.surveyButton.layer.cornerRadius = 10;
    self.surveyButton.backgroundColor = UIColor.blueColor;
    self.surveyButton.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
    self.surveyButton.alpha = 0.0;
    [self.surveyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.surveyButton setTitle:@"Survey" forState:UIControlStateNormal];
    [self.surveyButton addTarget:self action:@selector(handleSurveySelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.surveyButton];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];

    [self initTapResearchPlacement];
}

- (void)refreshTapResearchPlacement:(NSNotification*)notification {
    
    /* If we have a placement already we need to refresh that if the app is brought into foreground. */
    if (self.tapresearchPlacement) {
        self.surveyButton.alpha = 0.0;
        [self.activityIndicator startAnimating];
        [self initTapResearchPlacement];
    }
}

- (void)initTapResearchPlacement {
    
    [self.activityIndicator stopAnimating];
    [TapResearch initPlacementWithIdentifier:TRPlacementIdentifier placementBlock:^(TRPlacement *placement) {
        [self.activityIndicator stopAnimating];
        self.tapresearchPlacement = placement;
        if (placement.isSurveyWallAvailable && placement.placementCode != PLACEMENT_CODE_SDK_NOT_READY) {
            [self showSurveyAvailable];
        }
    }];
}

- (void)showSurveyAvailable {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.reInitButton.alpha = 0.0;
                         self.surveyButton.alpha = 1.0;
                     }
     ];
}

- (void)showReInit {

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.reInitButton.alpha = 1.0;
                     }
     ];
}

- (void)handleSurveySelected {
    
    if (self.tapresearchPlacement) {
        [self.tapresearchPlacement showSurveyWallWithDelegate:self];
    }
}

- (void)handleReInitSelected {
    
    [self initTapResearchPlacement];
}

#pragma mark - TapResearchSurveyDelegate

- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement {

    NSLog(@"Survey wall opened");
    self.surveyButton.alpha = 0.0;
}

- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement {

    NSLog(@"Survey wall dismissed");
    /* TRPlacemnt will be disabled after the survey wall was visible.
     If you want to show the placement again you'll have to initialize it again
     */
    [self showReInit];
}

@end
