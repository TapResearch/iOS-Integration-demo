//
//  ViewController.h
//  TestPod
//
//  Created by Ilan Caspi on 5/22/17.
//  Copyright © 2017 Ilan Caspi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapResearchSDK/TapResearch.h>

@interface ViewController : UIViewController<TapResearchSurveyDelegate, TapResearchRewardDelegate, TapResearchPlacementDelegate>

@property (strong, nonatomic) TRPlacement *tapresearchPlacement;

@end

