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

static NSString * const apiToken = @"7d08c962b40ac7aa0cf83c4d376fa36f";//@"<Your API Key>";
static NSString * const uniqueIdentifier = @"Nascar";//@"<UserIdentifier>";

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIButton *surveyButton;

@property (nonatomic, strong) NSMutableDictionary *placements;

@end

///---------------------------------------------------------------------------------------------
@implementation ViewController

///---------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];

	self.placements = [[NSMutableDictionary alloc] init];
	self.surveyButton.layer.cornerRadius = 10.0;
	self.surveyButton.alpha = 0.0;
	[self.activityIndicator startAnimating];
	
	[self initSDK];
}

///---------------------------------------------------------------------------------------------
///SDK must be initialized with an api token and uniqueIdentifier
- (void)initSDK {
	
	[TapResearch initWithApiToken:apiToken rewardDelegate:self placementDelegate:self];
	[TapResearch setUniqueUserIdentifier:uniqueIdentifier];
}

///---------------------------------------------------------------------------------------------
/// present survey wall only when surveys are available.
- (IBAction)handleSurveySelected:(id)sender {
	
	if (self.placements.count) {
		if (self.placements.count == 1) {
			[(TRPlacement*)self.placements.allValues[0] showSurveyWallWithDelegate:self];
		}
		else {
			UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"TapResearch" message:@"Choose an available placememt" preferredStyle:UIAlertControllerStyleAlert];
			for (NSString *key in self.placements.allKeys) {
				UIAlertAction *action = [UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[(TRPlacement*)self.placements[action.title] showSurveyWallWithDelegate:self];
				}];
				[controller addAction:action];
			}
			UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
			[controller addAction:action];
			[self presentViewController:controller animated:YES completion:nil];
		}
	}
}

//MARK: - TapResearchPlacementDelegate

///---------------------------------------------------------------------------------------------
/// After the SDK is initialized, this delegate is called for each placement
- (void)placementReady:(nonnull TRPlacement *)placement {
	NSLog(@"TapResearch: Placement Ready! %@, wall %d, hot %d, maxlen %ld, plcode %ld", placement.placementIdentifier, (int)placement.isSurveyWallAvailable, (int)placement.hasHotSurvey, placement.maxSurveyLength, placement.placementCode);

	[self.placements setObject:placement forKey:placement.placementIdentifier];

	dispatch_async( dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.surveyButton.alpha = 1.0;
		} completion:^(BOOL done) {
			self.surveyButton.alpha = 1.0;
			[self.activityIndicator stopAnimating];
		}];
	});
}

///---------------------------------------------------------------------------------------------
/// If the placement is not available for any reason, this delegate is called
- (void)placementUnavailable:(nonnull NSString *)placementId {
	NSLog(@"TapResearch: Placement Unavailable! %@", placementId);

	[self.placements removeObjectForKey:placementId];
	
	if (!self.placements.count) {
		dispatch_async( dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.surveyButton.alpha = 0.0;
			} completion:^(BOOL done) {
				self.surveyButton.alpha = 0.0;
				[self.activityIndicator startAnimating];
			}];
		});
	}
}

//MARK: - TapResearchSurveyDelegate

///---------------------------------------------------------------------------------------------
/// This delegate is called when the survey wall is opened
- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement; {
	NSLog(@"TapResearch: Modal opened with placement %@", placement.placementIdentifier);
}

///---------------------------------------------------------------------------------------------
/// This delegate is called when the survey wall is dismissed
- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement; {
	NSLog(@"TapResearch: Modal dismissed with placement %@", placement.placementIdentifier);
}

//MARK: - TapResearchRewardDelegate

///---------------------------------------------------------------------------------------------
/// When there are rewards this delegate is called with an array of TRReward objects.
/// This example implementation can handle multiple currency names in rewards.
- (void)tapResearchDidReceiveRewards:(nonnull NSArray<TRReward *> *)rewards {
	NSLog(@"Rewards (%ld) Received!", rewards.count);
		
	NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
	for (TRReward *reward in rewards) {
		if (values[reward.currencyName]) {
			long v = [values[reward.currencyName] longValue];
			v += reward.rewardAmount;
			values[reward.currencyName] = [NSNumber numberWithLong:v];
		}
		else {
			values[reward.currencyName] = [NSNumber numberWithLong:reward.rewardAmount];
		}
	}
	
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"You have just received "];
	int i = 1;
	int c = (int)values.allKeys.count;
	for (NSString *key in values) {
		[string appendFormat:@"%ld %@", [values[key] longValue], key];
		if (i == c - 1) {
			[string appendString:@" and "];
		}
		else if (i == c) {
			[string appendString:@" for your efforts!"];
		}
		else {
			[string appendString:@", "];
		}
		i++;
	}
	
	[self presentAlert:@"Congrats!" message: string];
}

///---------------------------------------------------------------------------------------------
- (void)presentAlert:(NSString*)title message:(NSString*)message {

	dispatch_async( dispatch_get_main_queue(), ^{
		UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		[controller addAction:action];
		[self presentViewController:controller animated:YES completion:nil];
	});
}

@end
