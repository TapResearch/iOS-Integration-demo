//
//  PlacementSelectorVC.h
//  
//
//  Created by Jeroen Verbeek on 10/24/22.
//  Copyright © 2022 TapResearch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapResearchSDK/TapResearch.h>
#import "PlacementCell.h"

@interface PlacementSelectorVC : UIViewController<TapResearchSurveyDelegate, TapResearchRewardDelegate, TapResearchPlacementDelegate, TapResearchEventDelegate, PlacementCellDelegate>

@end
