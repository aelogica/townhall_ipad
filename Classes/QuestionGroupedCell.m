//
//  QuestionGroupedCell.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "QuestionGroupedCell.h"
#import "Question.h"
#import "AsynchImageView.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"

@implementation QuestionGroupedCell

@synthesize subject, author, responseCount, userPoints, voteUpButton, voteDownButton, avatarImage;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		subject = [[UILabel alloc]init];
		subject.textAlignment = UITextAlignmentLeft;
		subject.font = [UIFont systemFontOfSize:12];
		
		subject.numberOfLines = 0;
		subject.lineBreakMode = UILineBreakModeWordWrap;
		subject.backgroundColor = [UIColor clearColor];
		
		author = [[UILabel alloc]init];
		author.textAlignment = UITextAlignmentLeft;
		author.font = [UIFont systemFontOfSize:9];
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
		[self.contentView addSubview:author];
		[self.contentView addSubview:userPoints];
		[self.contentView addSubview:responseCount];
		
		voteUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteUpButton.frame = CGRectMake(5.0, 2.0, 24.0, 24.0);									
		voteUpButton.backgroundColor = [UIColor clearColor];
		
		[voteUpButton addTarget:self action:@selector(voteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteUpButton setImage:[UIImage imageNamed:@"arrow_up_24.png"] forState:UIControlStateNormal];
		[voteUpButton setImage:[UIImage imageNamed:@"arrow_up_24_on.png"] forState:UIControlStateHighlighted];
		[voteUpButton setImage:[UIImage imageNamed:@"arrow_up_24_on.png"] forState:UIControlStateSelected];
		
		voteDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteDownButton.frame = CGRectMake(5.0, 27, 24.0, 24.0);									
		voteDownButton.backgroundColor = [UIColor clearColor];
		[voteDownButton addTarget:self action:@selector(voteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteDownButton setImage:[UIImage imageNamed:@"arrow_down_24.png"] forState:UIControlStateNormal];
		[voteDownButton setImage:[UIImage imageNamed:@"arrow_down_24_on.png"] forState:UIControlStateHighlighted];
		[voteDownButton setImage:[UIImage imageNamed:@"arrow_down_24_on.png"] forState:UIControlStateSelected];
		
		[self.contentView addSubview:voteUpButton];
		[self.contentView addSubview:voteDownButton];
		
		CGRect frame;
		frame.size.width=50; frame.size.height=42;
		frame.origin.x=30.f; frame.origin.y=5;
		avatarImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		[self.contentView addSubview:avatarImage];	
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
	CGSize size = [aQuestion.subject sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;	
	
	CGRect frame = CGRectMake(boundsX+80 ,5, size.width, size.height);
	subject.frame = frame;	
	frame= CGRectMake(boundsX+80 ,frame.size.height + frame.origin.y, 500, 15);
	author.frame = frame;	
	frame = CGRectMake(560, 5, 50, 35);
	responseCount.frame = frame;	
	frame = CGRectMake(560, 40, 40, 20);
	userPoints.frame = frame;	
	
	subject.text = aQuestion.subject;
	author.text = [NSString stringWithFormat:@"Posted by %@ at %@.", aQuestion.nuggetOriginator.displayName, @"December 18, 2010"];
	responseCount.text = [NSString stringWithFormat:@"%@", aQuestion.responseCount];
	userPoints.text = [NSString stringWithFormat:@"%@ pts", aQuestion.nuggetOriginator.userReputationString];
	voteUpButton.tag = aQuestion.nuggetId;
	voteDownButton.tag = aQuestion.nuggetId;
	[voteUpButton setSelected: NO];
	[voteDownButton setSelected: NO];	
	
	
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
