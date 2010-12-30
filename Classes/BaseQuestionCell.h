//
//  BaseQuestionCell.h
//  GenericTownHall
//
//  Created by David Ang on 12/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;
@class AsyncImageView;

@interface BaseQuestionCell : UITableViewCell {
	UILabel *subject;
	UILabel *author;
	UILabel *userPoints;
	UILabel *responseCount;
	UIButton *voteUpButton;
	UIButton *voteDownButton;
	UIImageView *voteBox;
	UIImageView *voteUpMeter;
	UIImageView *voteDownMeter;
	UIView *voteUpMeterDimmer;
	UIView *voteDownMeterDimmer;
    UIView *authorBackgroundView;
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
@property(nonatomic, retain) UIImageView *voteUpMeter;
@property(nonatomic, retain) UIImageView *voteBox;
@property(nonatomic, retain) UIImageView *voteDownMeter;

@end
