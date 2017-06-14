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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveSurveyAvilable)
                                                 name:@"SurveyAvailableNotification" object:nil];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.activityIndicator startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SurveyAvailableNotification" object:nil];
    self.activityIndicator = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recieveSurveyAvilable {
    
    [self.activityIndicator stopAnimating];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 170, 100, 30);
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.backgroundColor = UIColor.blueColor;
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setTitle:@"Survey" forState:UIControlStateNormal];
    [button setTitle:@"Survey" forState:UIControlStateFocused];

    [button addTarget:self action:@selector(handleSurveySelected) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    button.alpha = 0.0;
    [UIView animateWithDuration:0.75 animations:^{button.alpha = 1.0;}];
    [self.view addSubview:button];

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
