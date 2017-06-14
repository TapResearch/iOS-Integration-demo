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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [TapResearch initWithApiToken: @"<The API Token>" delegate:self];
    [TapResearch setUniqueUserIdentifier:@"<User Identifier>"];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
- (void)tapResearchOnSurveyAvailable
{
    NSLog(@"Surveys available");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SurveyAvailableNotification" object:nil];
}

- (void)tapResearchOnSurveyNotAvailable
{
    NSLog(@"No surveys are available");
    NSString *title = @"Survey update";
    NSString *message = [NSString stringWithFormat:@"No surveys are avilable please try again later"];
    [self showNotificationDialogwith:title message:message];
}


-(void)tapResearchDidReceiveRewardWithQuantity:(NSInteger)quantity transactionIdentifier:(NSString *)transactionIdentifier currencyName:(NSString *)currencyName payoutEvent:(NSInteger)payoutEvent
{
    NSLog(@"Reward Received!");
    NSString *title = @"Congrats!";
    NSString *message = [NSString stringWithFormat:@"You have just received %lu tokens for your efforts.", (long)quantity];
    [self showNotificationDialogwith:title message:message];

}

@end
