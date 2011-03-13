//
//  BaseQuestionCell.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "BaseQuestionCell.h"
#import "Question.h"
#import "AsynchImageView.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"
#import "ASIFormDataRequest.h"

@implementation BaseQuestionCell

@synthesize subject, author, responseCount, userPoints, voteUpButton, voteDownButton, avatarImage, voteBox, voteUpMeter, voteDownMeter;

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
		
		voteUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteUpButton.backgroundColor = [UIColor clearColor];
		
		[voteUpButton addTarget:self action:@selector(voteUpPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteUpButton setImage:[UIImage imageNamed:@"vote_up.png"] forState:UIControlStateNormal];
		[voteUpButton setImage:[UIImage imageNamed:@"vote_up.png"] forState:UIControlStateHighlighted];
		[voteUpButton setImage:[UIImage imageNamed:@"vote_up.png"] forState:UIControlStateSelected];

		voteDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
		voteDownButton.backgroundColor = [UIColor clearColor];
		[voteDownButton addTarget:self action:@selector(voteDownPressed:) forControlEvents:UIControlEventTouchUpInside];
		[voteDownButton setImage:[UIImage imageNamed:@"vote_down.png"] forState:UIControlStateNormal];
		[voteDownButton setImage:[UIImage imageNamed:@"vote_down.png"] forState:UIControlStateHighlighted];
		[voteDownButton setImage:[UIImage imageNamed:@"vote_down.png"] forState:UIControlStateSelected];
		
		voteUpMeter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meter_green.png"]];
		voteUpMeterDimmer = [[UIView alloc] initWithFrame:CGRectZero]; 
		[voteUpMeterDimmer setBackgroundColor:[UIColor blackColor]];
		
		voteDownMeter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meter_red.png"]];
		voteDownMeterDimmer = [[UIView alloc] initWithFrame:CGRectZero];
		[voteDownMeterDimmer setBackgroundColor:[UIColor blackColor]];
		
		voteBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vote_box.png"]];

		[self.contentView addSubview:voteBox];
		[self.contentView addSubview:voteUpMeter];
		[self.contentView addSubview:voteDownMeter];
		[self.contentView addSubview:voteUpMeterDimmer];
		[self.contentView addSubview:voteDownMeterDimmer];
		
		[self.contentView addSubview:voteUpButton];
		[self.contentView addSubview:voteDownButton];
		
		CGRect frame;
		frame.size.width=50; frame.size.height=42;
		frame.origin.x=1.f; frame.origin.y=5;
		//avatarImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		//[self.contentView addSubview:avatarImage];	
    }
    return self;
}

-(void)voteUpPressed:(UIButton *)button {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/votes/%@/toggle?format=json&ApiKey=%@", UIAppDelegate.serverDataUrl, button.tag, UIAppDelegate.serverApiKey]];	
	NSLog(@"Making a vote to Url: %@", url);
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:button.tag forKey:@"nuggetID"];
	[request setPostValue:@"TRUE" forKey:@"isup"];	
	[request setDelegate:self];		
	[request setValidatesSecureCertificate:NO];
	[request startAsynchronous];	
	
	[button setSelected: YES];
	
}

-(void)voteDownPressed:(UIButton *)button {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/votes/%@/toggle?format=json&ApiKey=%@", UIAppDelegate.serverDataUrl, button.tag, UIAppDelegate.serverApiKey]];	
	NSLog(@"i: %@", url);
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:button.tag forKey:@"nuggetID"];
	[request setPostValue:@"FALSE" forKey:@"isup"];	
	[request setDelegate:self];		
	[request setValidatesSecureCertificate:NO];
	[request startAsynchronous];
	
	[button setSelected: YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	// Create an array out of the returned json string
	id *results = [responseString JSONValue];
	
	if ([results isKindOfClass:[NSArray class]] || [results isKindOfClass:[NSDictionary class]])  { 
		
		NSLog(@"Http request succeeded: %@ Count: %d", responseString, [results count]);	
	} else {
		NSLog(@"Http request result bad data: %@", responseString);
	    
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message: @"We apologize but there has been an error on our server. Would you try again a little later our programmers are working hard to fix the error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];            
		[alert show];
		[alert release];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	
	NSLog(@"Http request failed: %@ Count: %d", error);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message: @"We apologize but there has been an error on our server. Would you try again a little later our programmers are working hard to fix the error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];            
	[alert show];
	[alert release];	
}


- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"Thank you for voting." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
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
