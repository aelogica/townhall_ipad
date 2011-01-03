//
//  DetailViewQuestionCell.m
//  GenericTownHall
//
//  Created by David Ang on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "DetailViewQuestionCell.h"
#import "Question.h"
#import "AsynchImageView.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"

@implementation DetailViewQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void)updateCellWithQuestion:(Question*)aQuestion {
	CGSize size = [aQuestion.subject sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(768.f, 55.f)];
	
	CGRect frame = CGRectMake(10.f, 0, 500.f, 80.f);
	subject.frame = frame;	
	
	CGFloat authorOriginY = frame.size.height + frame.origin.y;
	
	frame = CGRectMake(0.f, authorOriginY, 768.f, 25.f);
	authorBackgroundView.frame = frame;
	frame = CGRectMake(10.f, authorOriginY, 768.f, 25.f);
	author.frame = frame;	
	frame = CGRectMake(260, 5, 50, 35);
	responseCount.frame = frame;	
	frame = CGRectMake(260, 40, 40, 20);
	userPoints.frame = frame;	
	
	subject.text = aQuestion.subject;
	author.text = [NSString stringWithFormat:@"Posted by %@ at %@", aQuestion.nuggetOriginator.displayName, aQuestion.dateCreatedFormatted];
	responseCount.text = [NSString stringWithFormat:@"%@", aQuestion.responseCount];
	userPoints.text = [NSString stringWithFormat:@"%@ pts", aQuestion.nuggetOriginator.userReputationString];
	//voteUpButton.tag = (int)aQuestion.nuggetId;
	//voteDownButton.tag = (int)aQuestion.nuggetId;
	//[voteUpButton setSelected: NO];
	//[voteDownButton setSelected: NO];	
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	CGFloat voteBarStartX = 600.f;
	CGFloat voteBarStartY = 5.f;
	
    if(appDelegate.currentOrientation == UIInterfaceOrientationLandscapeLeft || appDelegate.currentOrientation == UIInterfaceOrientationLandscapeRight) {
		voteBarStartX = 540.f;
	} 
	voteBox.frame = CGRectMake(voteBarStartX - 3.f, voteBarStartY - 2.f, 139.0, 68.0);											
	voteUpButton.frame = CGRectMake(voteBarStartX + 102.f, voteBarStartY, 32.0, 31.0);									
	voteDownButton.frame = CGRectMake(voteBarStartX + 102.f, voteBarStartY + 33.f, 32.0, 31.0);									
	voteUpMeter.frame = CGRectMake(voteBarStartX, voteBarStartY, 100.0, 31.0);																 
	voteDownMeter.frame = CGRectMake(voteBarStartX, voteBarStartY + 33.f, 100.0, 31.0);									
	
	float  upVoteBarHeight = [aQuestion.votes.upPercentage floatValue]/100;
	float  downVoteBarHeight = [aQuestion.votes.downPercentage floatValue]/100;
	upVoteBarHeight = upVoteBarHeight * 50;
	downVoteBarHeight = downVoteBarHeight *50;
	CGRect voteUpFrame;
	voteUpFrame.size.width = voteUpMeter.frame.size.width - upVoteBarHeight;
	voteUpFrame.size.height = 31.f;
	voteUpFrame.origin.x = voteBarStartX;
	voteUpFrame.origin.y = voteBarStartY;
	
	CGRect voteDownFrame;
	voteDownFrame.size.width=voteDownMeter.frame.size.width - downVoteBarHeight;
	voteDownFrame.size.height = 31.f;
	voteDownFrame.origin.x = voteBarStartX;
	voteDownFrame.origin.y = voteBarStartY + 33.f;
	
	voteUpMeterDimmer.frame = voteUpFrame;
	voteDownMeterDimmer.frame = voteDownFrame;	
	
	//[avatarImage loadImageFromURL:[NSURL URLWithString:aQuestion.nuggetOriginator.avatar]];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
