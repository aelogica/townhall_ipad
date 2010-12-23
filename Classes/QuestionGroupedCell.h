//
//  QuestionGroupedCell.h
//  GenericTownHall
//
//  Created by David Ang on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;
@class AsyncImageView;

@interface QuestionGroupedCell : UITableViewCell {
	UILabel *subject;
	UILabel *author;
	UILabel *userPoints;
	UILabel *responseCount;
	UIButton *voteUpButton;
	UIButton *voteDownButton;
	AsyncImageView* avatarImage;
}

-(void)updateCellWithQuestion:(Question*)aQuestion;

@property(nonatomic, retain) UILabel *subject;
@property(nonatomic, retain) UILabel *author;
@property(nonatomic, retain) UILabel *userPoints;
@property(nonatomic, retain) UILabel *responseCount;
@property(nonatomic, retain) UIButton *voteUpButton;
@property(nonatomic, retain) UIButton *voteDownButton;
@property(nonatomic, retain) AsyncImageView *avatarImage;

@end
