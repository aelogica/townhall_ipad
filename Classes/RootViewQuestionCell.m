//
//  RootViewQuestionCell.m
//  GenericTownHall
//
//  Created by David Ang on 12/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "RootViewQuestionCell.h"
#import "GenericTownHallAppDelegate.h"

@implementation RootViewQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.backgroundView.backgroundColor = UIColorFromRGB(0xdedede);		
		//selectedBackgroundView.backgroundColor = UIColorFromRGB(0x93c843);
		[voteUpMeter setHidden:YES];
		[voteDownMeter setHidden:YES];
		[voteUpButton setHidden:YES];
		[voteDownButton setHidden:YES];
		[voteBox setHidden:YES];
		[authorBackgroundView setBackgroundColor:UIColorFromRGB(0xababab)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
