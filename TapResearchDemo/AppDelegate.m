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
    [TapResearch initWithApiToken: @"<API Token>" delegate:self];
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


-(void)tapResearchDidReceiveReward:(TRReward *)reward
{
    NSLog(@"Reward Received!");
    NSString *title = @"Congrats!";
    NSString *message = [NSString stringWithFormat:@"You have just received %lu %@ for your efforts.", (long)reward.rewardAmount, reward.currencyName];
    [self showNotificationDialogwith:title message:message];
}

@end
