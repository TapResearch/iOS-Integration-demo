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
    [self.surveyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.surveyButton setTitle:@"Survey" forState:UIControlStateNormal];
    
    [self.surveyButton addTarget:self action:@selector(handleSurveySelected) forControlEvents:UIControlEventTouchUpInside];
    self.surveyButton.center = self.view.center;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.activityIndicator startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSurveyAvailable)
                                                 name:@"SurveyAvailableNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SurveyAvailableNotification" object:nil];
    self.activityIndicator = nil;
}

- (void)receiveSurveyAvailable
{
    [self.activityIndicator stopAnimating];
    
    self.surveyButton.alpha = 0.0;
    [self.view addSubview:self.surveyButton];
    [UIView animateWithDuration:0.75 animations:^{self.surveyButton.alpha = 1.0;}];
}

- (void)handleSurveySelected
{
    [TapResearch showSurveyWithDelegate:self];
    /*
     Also can be called this way
     [TapResearch showSurveyWithIdentifier:@"<Offer Identifier>" delegate:this];
     */
}

#pragma mark - TapResearchSurveyDelegate

- (void)tapResearchSurveyModalOpened
{
    NSLog(@"Survey modal opened");
}

- (void)tapResearchSurveyModalDismissed
{
    NSLog(@"Survey modal closed");
}

@end
