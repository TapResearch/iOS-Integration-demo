//
//  PlacementCell.m
//
//
//  Created by Jeroen Verbeek on 10/24/22.
//  Copyright © 2022 TapResearch. All rights reserved.
//

#import "PlacementSelectorVC.h"
#import <TapResearchSDK/TapResearchSDK.h>

@implementation PlacementCell

///---------------------------------------------------------------------------------------------
+ (PlacementCell *)cell:(UITableView *)tableView
			  indexPath:(NSIndexPath *)indexPath
			  placement:(TRPlacement *)placement
			   delegate:(NSObject<PlacementCellDelegate> *)delegate
{
	PlacementCell *cell = (PlacementCell *)[tableView dequeueReusableCellWithIdentifier:@"PlacementCell"];
	if (!cell) {
		cell = [[PlacementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlacementCell"];
	}
	[cell fillCell:placement indexPath:indexPath delegate:delegate];
	return cell;
}

///---------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.eventButton.layer.borderColor = UIColor.systemBlueColor.CGColor;
	self.eventButton.layer.borderWidth = 1;
	self.eventButton.layer.cornerRadius = 7;
	[self.eventButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
	self.eventButton.tintColor = UIColor.systemBlueColor;
}

///---------------------------------------------------------------------------------------------
- (void)fillCell:(TRPlacement *)placement
	   indexPath:(NSIndexPath *)indexPath
		delegate:(NSObject<PlacementCellDelegate> *)delegate
{
	
	self.indexPath = indexPath;
	self.delegate = delegate;
	
	self.placementLabel.text = placement.placementIdentifier;
	self.eventDetailLabel.text = [NSString stringWithFormat:@"%lu TREvents", placement.events.count];
	if (placement.events.count > 0) {
		self.eventButton.hidden = NO;
	}
	else {
		self.eventButton.hidden = YES;
	}
}

///---------------------------------------------------------------------------------------------
- (IBAction)eventButtonTapped {
	
	if (self.indexPath && self.delegate) {
		[self.delegate displayEventSelected:self.indexPath];
	}
}

@end
