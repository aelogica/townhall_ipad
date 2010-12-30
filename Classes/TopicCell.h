//
//  TopicCell.h
//  GenericTownHall
//
//  Created by David Ang on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopicCell : UITableViewCell {
	UILabel *name;
}

@property(nonatomic, retain) UILabel *name;

-(void)updateCellWithModel:(id*)aModel;

@end