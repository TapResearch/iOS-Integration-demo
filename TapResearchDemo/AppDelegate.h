//
//  AppDelegate.h
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapResearchSDK/TapResearchSDK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, TapResearchRewardDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

