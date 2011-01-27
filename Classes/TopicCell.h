//
//  TopicCell.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>


@interface TopicCell : UITableViewCell {
	UILabel *name;
}

@property(nonatomic, retain) UILabel *name;

-(void)updateCellWithModel:(id*)aModel;

@end
