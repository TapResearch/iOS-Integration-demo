//
//  AppDelegate.m
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [TapResearch initWithApiToken:@"API_TOKEN" rewardDelegate: self placementDelegate: self];
//    [TapResearch initWithApiToken: @"API_TOKEN" delegate:self];

    [TapResearch setUniqueUserIdentifier:@"<User Identifier>"];
    return YES;
}


- (void)showNotificationDialogwith:(NSString *)title message:(NSString *)message
{
    NSLog(@"No surveys available");
    
    if ([UIAlertController class]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:action];
        
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:message cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
#pragma GCC diagnostic pop
        
    }

}

#pragma mark - TapResearch

- (void)tapResearchDidReceiveRewards:(nonnull NSArray<TRReward *> *)rewards {
//    NSLog(@"Reward Received!");
//    NSString *title = @"Congrats!";
//    NSString *message = [NSString stringWithFormat:@"You have just received %lu %@ for your efforts.", (long)rewards.firstObject, rewards.firstObject.currencyName];
//    [self showNotificationDialogwith:title message:message];
    
    NSLog(@"Rewards (%ld) Received!", rewards.count);
    NSString *title = @"Congrats!";

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
    
    NSMutableString *message = [[NSMutableString alloc] initWithString:@"You have just received "];
    int i = 1; // 1 to matchup with count value for keys
    int c = (int)values.allKeys.count;
    for (NSString *key in values) {
        [message appendFormat:@"%ld %@", [values[key] longValue], key];
        if (i == c - 1) {
            [message appendString:@" and "];
        }
        else if (i == c) {
            [message appendString:@" for your efforts!"];
        }
        else {
            [message appendString:@", "];
        }
        i++;
    }

    dispatch_async( dispatch_get_main_queue(), ^{
        [self showNotificationDialogwith:title message:message];
    });
}

- (void)placementReady:(nonnull TRPlacement *)placement {
    NSLog(@"UPDATED PLACEMENT! %@, wall %d, hot %d, maxlen %ld, plcode %ld", placement.placementIdentifier, placement.isSurveyWallAvailable, placement.hasHotSurvey, placement.maxSurveyLength, placement.placementCode);

    [self.placements setObject:placement forKey:placement.placementIdentifier];
}

- (void)placementUnavailable:(nonnull NSString *)placementId {
    NSLog(@"PLACEMENT UNAVAILABLE! %@", placementId);

    [self.placements removeObjectForKey:placementId];
}

@end
