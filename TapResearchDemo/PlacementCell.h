//
//  PlacementCell.h
//  
//
//  Created by Jeroen Verbeek on 10/24/22.
//  Copyright © 2022 TapResearch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapResearchSDK/TapResearch.h>

@protocol PlacementCellDelegate <NSObject>

- (void)displayEventSelected:(NSIndexPath *)indexPath;

@end

@interface PlacementCell : UITableViewCell

@property (readwrite, weak) IBOutlet UILabel *placementLabel;
@property (readwrite, weak) IBOutlet UILabel *eventDetailLabel;
@property (readwrite, weak) IBOutlet UIButton *eventButton;

@property (readwrite, weak) NSIndexPath *indexPath;
@property (readwrite, weak) NSObject<PlacementCellDelegate>* delegate;

+ (PlacementCell *)cell:(UITableView *)tableView
			  indexPath:(NSIndexPath *)indexPath
			  placement:(TRPlacement *)placement
			   delegate:(NSObject<PlacementCellDelegate> *)delegate;
@end
