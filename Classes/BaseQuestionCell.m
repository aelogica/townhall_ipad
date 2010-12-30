//
//  BaseQuestionCell.m
//  GenericTownHall
//
//  Created by David Ang on 12/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BaseQuestionCell.h"
#import "Question.h"
#import "AsynchImageView.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"

@implementation BaseQuestionCell

@synthesize subject, author, responseCount, userPoints, voteUpButton, voteDownButton, avatarImage, voteUpMeter, voteDownMeter;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backgroundView.backgroundColor = UIColorFromRGB(0x77a236);		
		self.backgroundView = backgroundView;	
		
		UIView *selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		selectedBackgroundView.backgroundColor = UIColorFromRGB(0x93c843);
		selectedBackgroundView.alpha = 0.3f;	
		selectedBackgroundView.opaque = NO;
		self.selectedBackgroundView = selectedBackgroundView;
		
		authorBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];		
		authorBackgroundView.backgroundColor = UIColorFromRGB(0x54811c);			
		
		subject = [[UILabel alloc]init];
		subject.textAlignment = UITextAlignmentLeft;
		subject.font = [UIFont systemFontOfSize:16];
		
		subject.numberOfLines = 0;
		subject.lineBreakMode = UILineBreakModeWordWrap;
		subject.backgroundColor = [UIColor clearColor];
		
		author = [[UILabel alloc]init];
		author.textAlignment = UITextAlignmentLeft;
		author.font = [UIFont systemFontOfSize:14];
		author.backgroundColor = [UIColor clearColor];
		
		responseCount = [[UILabel alloc]init];
		responseCount.textAlignment = UITextAlignmentCenter;
		responseCount.font = [UIFont systemFontOfSize:20];		
		responseCount.textColor = [UIColor blueColor];
		responseCount.backgroundColor = [UIColor clearColor];
		
		userPoints = [[UILabel alloc]init];
		userPoints.textAlignment = UITextAlignmentCenter;
		userPoints.font = [UIFont systemFontOfSize:9];		
		userPoints.textColor = [UIColor blueColor];		
		userPoints.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:subject];
		[self.contentView addSubview:authorBackgroundView];
		[self.contentView addSubview:author];
		//[self.contentView addSubview:userPoints];
		//[self.contentView addSubview:responseCount];
		
		
		CGFloat voteBarStartX = 600.f;
		CGFloat voteBarStartY = 5.f;
		
		voteUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteUpButton.frame = CGRectMake(voteBarStartX + 102.f, voteBarStartY, 32.0, 31.0);									
		voteUpButton.backgroundColor = [UIColor clearColor];
		
		[voteUpButton addTarget:self action:@selector(voteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteUpButton setImage:[UIImage imageNamed:@"vote_up.png"] forState:UIControlStateNormal];
		[voteUpButton setImage:[UIImage imageNamed:@"vote_up.png"] forState:UIControlStateHighlighted];
		[voteUpButton setImage:[UIImage imageNamed:@"vote_up.png"] forState:UIControlStateSelected];

		voteDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteDownButton.frame = CGRectMake(voteBarStartX + 102.f, voteBarStartY + 33.f, 32.0, 31.0);									
		voteDownButton.backgroundColor = [UIColor clearColor];
		[voteDownButton addTarget:self action:@selector(voteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteDownButton setImage:[UIImage imageNamed:@"vote_down.png"] forState:UIControlStateNormal];
		[voteDownButton setImage:[UIImage imageNamed:@"vote_down.png"] forState:UIControlStateHighlighted];
		[voteDownButton setImage:[UIImage imageNamed:@"vote_down.png"] forState:UIControlStateSelected];
		
		voteUpMeter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meter_green.png"]];
		voteUpMeter.frame = CGRectMake(voteBarStartX, voteBarStartY, 100.0, 31.0);																 
		voteUpMeterDimmer = [[UIView alloc] initWithFrame:CGRectMake(voteBarStartX, voteBarStartY, 0.0, 31.0)];
		[voteUpMeterDimmer setBackgroundColor:[UIColor blackColor]];
		
		voteDownMeter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meter_red.png"]];
		voteDownMeter.frame = CGRectMake(voteBarStartX, voteBarStartY + 33.f, 100.0, 31.0);									
		voteDownMeterDimmer = [[UIView alloc] initWithFrame:CGRectMake(voteBarStartX, voteBarStartY + 33.f, 50.0, 31.0)];
		[voteDownMeterDimmer setBackgroundColor:[UIColor blackColor]];
		
		UIImageView *voteBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vote_box.png"]];
		voteBox.frame = CGRectMake(voteBarStartX - 3.f, voteBarStartY - 2.f, 139.0, 68.0);									

		[self.contentView addSubview:voteBox];
		[self.contentView addSubview:voteUpMeter];
		[self.contentView addSubview:voteDownMeter];
		[self.contentView addSubview:voteDownMeterDimmer];
		[self.contentView addSubview:voteUpMeterDimmer];

		
		[self.contentView addSubview:voteUpButton];
		[self.contentView addSubview:voteDownButton];
		
		CGRect frame;
		frame.size.width=50; frame.size.height=42;
		frame.origin.x=1.f; frame.origin.y=5;
		avatarImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		//[self.contentView addSubview:avatarImage];	
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void)voteUpPressed:(UIButton *)button {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/votes/%@/toggle?format=xml", UIAppDelegate.serverDataUrl, button.tag]];	
	NSLog(@"Making a vote to Url: %@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = [NSString stringWithFormat:@"nuggetID=%@&isup=TRUE", button.tag];  
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: postData];
	
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(postRequestHandler:finishedWithData:error:)];
	[button setSelected: YES];
	
}

-(void)voteDownPressed:(UIButton *)button {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/votes/%@/toggle?format=xml", UIAppDelegate.serverDataUrl, button.tag]];	
	NSLog(@"Making a vote to Url: %@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = [NSString stringWithFormat:@"nuggetID=%@&isup=FALSE", button.tag];  
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: postData];
	
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(postRequestHandler:finishedWithData:error:)];
	[button setSelected: YES];
}

-(void)updateCellWithQuestion:(Question*)aQuestion {
	CGSize size = [aQuestion.subject sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(768.f, 55.f)];
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;	
	
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
	
	float  upVoteBarHeight = [aQuestion.votes.upPercentage floatValue]/100;
	float  downVoteBarHeight = [aQuestion.votes.downPercentage floatValue]/100;
	upVoteBarHeight = upVoteBarHeight * 50;
	downVoteBarHeight = downVoteBarHeight *50;
	CGRect voteUpFrame;
	voteUpFrame.size.width=voteUpMeter.frame.size.width - upVoteBarHeight;
	voteUpFrame.size.height=voteUpMeterDimmer.frame.size.height;
	voteUpFrame.origin.x=voteUpMeterDimmer.frame.origin.x;
	voteUpFrame.origin.y=voteUpMeterDimmer.frame.origin.y;
	
	CGRect voteDownFrame;
	voteDownFrame.size.width=voteDownMeter.frame.size.width - downVoteBarHeight;
	voteDownFrame.size.height=voteDownMeterDimmer.frame.size.height;
	voteDownFrame.origin.x=voteDownMeterDimmer.frame.origin.x;
	voteDownFrame.origin.y=voteDownMeterDimmer.frame.origin.y;
	
	voteUpMeterDimmer.frame = voteUpFrame;
	voteDownMeterDimmer.frame = voteDownFrame;
	
	
	[avatarImage loadImageFromURL:[NSURL URLWithString:aQuestion.nuggetOriginator.avatar]];
	
}

- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
}

- (void)dealloc {
	/*
	 [subject dealloc];
	 [author dealloc];
	 [responseCount dealloc];
	 [userPoints dealloc];
	 [voteUpButton dealloc];
	 [voteDownButton dealloc];
	 [avatarImage dealloc];	
	 */
    [super dealloc];
}



@end
