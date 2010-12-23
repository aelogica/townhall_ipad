//
//  QuestionPlainCell.h
//  GenericTownHall
//
//  Created by David Ang on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionPlainCell : UITableViewCell {
	UILabel *subject;
	UILabel *author;
	UILabel *userPoints;
	UILabel *responseCount;
	UIButton *voteUpButton;
	UIButton *voteDownButton;
	
}

@property(nonatomic, retain) UILabel *subject;
@property(nonatomic, retain) UILabel *author;
@property(nonatomic, retain) UILabel *userPoints;
@property(nonatomic, retain) UILabel *responseCount;
@property(nonatomic, retain) UIButton *voteUp;
@property(nonatomic, retain) UIButton *voteDown;
@end
