    //
//  ResponsesViewController.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "ResponsesViewController.h"

#import "Question.h"
#import "ResponseCell.h"
#import "Response.h"
#import "LoginDialog.h"
#import "ResponseDialog.h"
#import "TwitterView.h"

@implementation ResponsesViewController

@synthesize curQuestion;

- (void) loadView {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
	
    [super loadView];
	[super addTableView:UITableViewStylePlain];	
	[super addHeader];
	[headerView setBackgroundColor:UIColorFromRGB(0xd5d8de)];
	
	// UI for headerView
	UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.0, 600.f, 50.f)];
	subjectLabel.backgroundColor = [UIColor clearColor];
	subjectLabel.numberOfLines = 0;
	subjectLabel.lineBreakMode = UILineBreakModeWordWrap;
	subjectLabel.textColor = [UIColor blackColor];
	subjectLabel.font = [UIFont systemFontOfSize:15];
	
	UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 60.f, 600.f, 30.f)];
	authorLabel.backgroundColor = UIColorFromRGB(0xbdbfc5);
	authorLabel.textColor = UIColorFromRGB(0x000000);
	authorLabel.font = [UIFont systemFontOfSize:14];
	authorLabel.layer.cornerRadius = 4.f;
	
	[headerView addSubview:subjectLabel];
	[headerView addSubview:authorLabel];
	
	// Add buttons to toolbar
	UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Responses" 
																style:UIBarButtonItemStylePlain target:nil action:nil];
	
	UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"Post response" 
																style:UIBarButtonItemStyleBordered target:self action:@selector(postButtonPressed:)];
	// did not work
//	UIBarButtonItem *shareOnTwitterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-twitter.png"] style:UIBarButtonItemStylePlain
//																		target:self action:@selector(tweetButtonPressed)];
	
	UIImage *twitterImage = [UIImage imageNamed:@"icon-twitter.png"];
	UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	twitterButton.bounds = CGRectMake( 0, 0, twitterImage.size.width, twitterImage.size.height );
	[twitterButton setImage:twitterImage forState:UIControlStateNormal];	
	[twitterButton addTarget:self action:@selector(twitterShareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *twitterBtn = [[UIBarButtonItem alloc] initWithCustomView:twitterButton]; //target:self action:@selector(tweetButtonPressed)
	
	UIImage *fbImage = [UIImage imageNamed:@"icon-facebook.png"];
	
	UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
	fbButton.bounds = CGRectMake( 0, 0, fbImage.size.width, fbImage.size.height );
	[fbButton setImage:fbImage forState:UIControlStateNormal];	
	[fbButton addTarget:self action:@selector(facebookShareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *fbBtn = [[UIBarButtonItem alloc] initWithCustomView:fbButton]; 
	
	//Use this to put space in between your toolbox buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	//Add buttons to the array
	NSArray *tbarItems = [NSArray arrayWithObjects: button1, flexItem, twitterBtn, fbBtn, button2, nil];
	
	//release buttons
	[button1 release];
	[button2 release];
	[flexItem release];
	
	// Add array of buttons to toolbar
	[toolbar setItems:tbarItems animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	// Remove all objects else this will show old data from previous list 
	[items removeAllObjects];
	
	[super viewDidAppear:NO];
	
	// Set the subject and author in the header
	UILabel *subject = (UILabel*)[headerView.subviews objectAtIndex:0];
	UILabel *author = (UILabel*)[headerView.subviews objectAtIndex:1];
	subject.text = curQuestion.body;
	author.text = [NSString stringWithFormat:@"    Posted by %@ at %@ (%@ pts).", curQuestion.nuggetOriginator.displayName, curQuestion.dateCreatedFormatted, curQuestion.nuggetOriginator.userReputationString];
}

- (NSString*)getServiceUrl {
	NSString *url = [NSURL URLWithString:[NSString stringWithFormat:@"questions/%@", curQuestion.nuggetId]];
	return url;
}

- (void)handleHttpResponse:(NSString*)responseString {	
	NSDictionary *results = [responseString JSONValue];	
	NSArray *allResponses = [results objectForKey:@"Responses"];
	
	if ([allResponses count] ) {
		for (NSDictionary *objectInstance in allResponses) {
			Response *response = [[Response alloc] init];
			response.body = [objectInstance objectForKey:@"Body"];			
			
			NSDictionary *originator = [objectInstance objectForKey:@"Originator"];
			response.originator.displayName = [originator objectForKey:@"DisplayName"];
			response.originator.userReputationString = [originator objectForKey:@"UserReputationString"];				
			
			[items addObject: response ];
			[response release];
		}	
	} 
}

-(void)facebookShareButtonPressed:(UIButton*)button {
	NSString *serverUrl = [UIAppDelegate.serverDataUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
	NSString *link = [NSString stringWithFormat:@"%@/questions/%@/%@", serverUrl, curQuestion.nuggetId, curQuestion.subjectSlug];
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"Share on Facebook",  @"user_message_prompt",
								   @"", @"message",
								   link, @"link",
								   @"See what people are talking about on TOWNHALL:", @"name",
								   @"", @"caption",
								   link, @"description",								  
								   nil];	
	
	[UIAppDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
}

- (NSString *)urlEncodeValue:(NSString *)str {
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	return [result autorelease];
}

-(void)twitterShareButtonPressed:(UIButton*)button {
	
	int viewHeight = UIAppDelegate.appHeight;
//	NSString *url = [NSString stringWithFormat:@"http://twitter.com/login?redirect_after_login=%%2Fhome%%3Fstatus%%3DSee%%2520what%%2520people%%2520are%%2520talking%%2520about%%2520on%%2520TOWNHALL%%3A%%2520http%%3A%%2F%%2Ftownhall2.cloudapp.net%%252fquestions%%252f%@%%252f%@", curQuestion.nuggetId, curQuestion.subjectSlug];
	NSString *url = [NSString stringWithFormat:@"https://townhall2.cloudapp.net/link/share?endUrl=https%%253a%%252f%%252ftownhall2.cloudapp.net%%25252fquestions%%25252f%@%%25252f%@&shareUrl=http%%3A%%2F%%2Ftwitter.com%%2Fhome%%3Fstatus%%3DSee%%20what%%20people%%20are%%20talking%%20about%%20on%%20TOWNHALL%%3A%%20%%7Bshare%%7D", curQuestion.nuggetId, curQuestion.subjectSlug];
	
	TwitterView *twitterView = [[TwitterView alloc] initWithFrame:CGRectMake(0, UIAppDelegate.appHeight, UIAppDelegate.appWidth, viewHeight) url:url];

	CGRect frame = twitterView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	
	frame.origin.y =  UIAppDelegate.appHeight - viewHeight - 44.f;
	twitterView.frame = frame;
	
	[UIView commitAnimations];
	
	[self.view addSubview:twitterView];
}



-(void)postButtonPressed:(UIBarButtonItem *)button {
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	if(appDelegate.isLogin == NO) {
		LoginDialog *dialog = [[LoginDialog alloc] initWithFrame:CGRectMake(0.f, 20.f, 600.f, 250.f)];
		[dialog setupView:nil];
		[dialog doAppearAnimation: self.view.window];	
		[self.view.window addSubview:dialog];
		[dialog release];
	} else {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];	
		
		ResponseDialog * dialog = [[ResponseDialog alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 300.f)];
		[dialog setupView:curQuestion];
		
		[dialog doAppearAnimation: self.view.window];	
		[self.view.window addSubview:dialog];
		
		
		[dialog release];
	}
}

#pragma mark Event listener methods

- (void)backButtonPressed:(UIBarButtonItem *)button {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToTopics" object:nil userInfo:nil];
}

#pragma mark Table view methods

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";

	ResponseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[[ResponseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}	

	Response *response = (Response *)[items objectAtIndex:indexPath.row];
	[cell updateCellWithModel:response];		
	
	if( [indexPath row] % 2)
		[cell setBackgroundColor:[UIColor whiteColor]];
	else
		[cell setBackgroundColor:UIColorFromRGB(0xEDEDED)];
	
	return cell;
	
}
- (void)dealloc {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);

    [super dealloc];
}

@end
