//
//  PlacementSelectorVC.m
//
//
//  Created by Jeroen Verbeek on 10/24/22.
//  Copyright © 2022 TapResearch. All rights reserved.
//

#import <TapResearchSDK/TapResearchSDK.h>
#import "PlacementSelectorVC.h"

static NSString * const tapResearchApiToken = @"<API_TOKEN>"
static NSString * const uniqueUserIdentifier = @"<player_identifier>";

@interface PlacementSelectorVC ()

@property (readwrite, weak) IBOutlet UITableView *tableView;
@property (readwrite, strong) NSMutableDictionary *placements;

@end

@implementation PlacementSelectorVC

///---------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];

	self.placements = [[NSMutableDictionary alloc] init];
	
	[self initSDK];
}

///---------------------------------------------------------------------------------------------
- (void)initSDK {
	
	[TapResearch initWithApiToken:tapResearchApiToken rewardDelegate:self placementDelegate:self];
	[TapResearch setUniqueUserIdentifier:uniqueUserIdentifier];
}

///---------------------------------------------------------------------------------------------
-(TRPlacementCustomParameterList *)buildCustomParameters {
	
	TRPlacementCustomParameterList *parameterList = [[TRPlacementCustomParameterList alloc] init];
	TRPlacementCustomParameter *param = [TRPlacementCustomParameter new];
	[[[[param builder] key: @"<KEY>"] value: @"<VALUE>"] build];
	[parameterList addParameter:param];
	return parameterList;
}

///---------------------------------------------------------------------------------------------
- (void)displayEventSelected:(NSIndexPath *)indexPath {
	
	TRPlacement *placement = (TRPlacement *)self.placements.allValues[indexPath.row];
	if (placement && placement.events.count > 0) {
		TREvent *event = placement.events[0];
		if (event) {
			[placement displayEvent:event.identifier withDisplayDelegate:self surveyDelegate:self customParameters:[self buildCustomParameters]];
		}
	}
}

//MARK: - UITableView

///---------------------------------------------------------------------------------------------
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	TRPlacement *placement = (TRPlacement *)self.placements.allValues[indexPath.row];
	[placement showSurveyWallWithDelegate:self customParameters:[self buildCustomParameters]];
}

///---------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)secton {
	return self.placements.count;
}

///---------------------------------------------------------------------------------------------
-(UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

	TRPlacement *placement = (TRPlacement *)self.placements.allValues[indexPath.row];
	return [PlacementCell cell:tableView indexPath:indexPath placement:placement delegate:self];
}

//MARK: - TapResearchPlacementDelegate

///---------------------------------------------------------------------------------------------
- (void)placementReady:(nonnull TRPlacement *)placement {
	NSLog(@"TapResearch: Placement Ready! %@, wall %d, hot %d, maxlen %ld, plcode %ld", placement.placementIdentifier, (int)placement.isSurveyWallAvailable, (int)placement.hasHotSurvey, placement.maxSurveyLength, placement.placementCode);

	[self.placements setObject:placement forKey:placement.placementIdentifier];

	dispatch_async( dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

///---------------------------------------------------------------------------------------------
- (void)placementUnavailable:(nonnull NSString *)placementId {
	NSLog(@"TapResearch: Placement Unavailable! %@", placementId);
	
	[self.placements removeObjectForKey:placementId];

	dispatch_async( dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

//MARK: - TapResearchSurveyDelegate

///---------------------------------------------------------------------------------------------
- (void)tapResearchSurveyWallOpenedWithPlacement:(TRPlacement *)placement; {
	NSLog(@"TapResearch: Modal opened with placement %@", placement.placementIdentifier);
}

///---------------------------------------------------------------------------------------------
- (void)tapResearchSurveyWallDismissedWithPlacement:(TRPlacement *)placement; {
	NSLog(@"TapResearch: Modal dismissed with placement %@", placement.placementIdentifier);
}

//MARK: - TapResearchRewardDelegate

///---------------------------------------------------------------------------------------------
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
