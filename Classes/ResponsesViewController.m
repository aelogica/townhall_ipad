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


@implementation ResponsesViewController

@synthesize curQuestion;

- (void) loadView {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
	
    [super loadView];
	[super addTableView:UITableViewStylePlain];	
	[super addHeader];
	
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
	
	
	
	//Use this to put space in between your toolbox buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	//Add buttons to the array
	NSArray *items = [NSArray arrayWithObjects: button1, flexItem, button2, nil];
	
	//release buttons
	[button1 release];
	[button2 release];
	[flexItem release];
	
	// Add array of buttons to toolbar
	[toolbar setItems:items animated:NO];
}

- (NSString*)getServiceUrl {
	NSString *url = [NSURL URLWithString:[NSString stringWithFormat:@"questions/%@", curQuestion.nuggetId]];
	return url;
}

- (void)handleHttpResponse:(NSString*)responseString {
	
	UILabel *subject = (UILabel*)[headerView.subviews objectAtIndex:0];
	UILabel *author = (UILabel*)[headerView.subviews objectAtIndex:1];
	subject.text = curQuestion.body;
	author.text = [NSString stringWithFormat:@"    Posted by %@ at %@ (%@ pts).", curQuestion.nuggetOriginator.displayName, curQuestion.dateCreatedFormatted, curQuestion.nuggetOriginator.userReputationString];
	
	NSDictionary *results = [responseString JSONValue];
	NSArray *allResponses = [results objectForKey:@"Responses"];
	
	if ([allResponses count] > 1) {
		for (NSDictionary *objectInstance in allResponses) {
			Response *response = [[Response alloc] init];
			response.body = [objectInstance objectForKey:@"Body"];			
			
			NSDictionary *originator = [objectInstance objectForKey:@"Originator"];
			response.originator.displayName = [originator objectForKey:@"DisplayName"];
			response.originator.userReputationString = [originator objectForKey:@"UserReputationString"];				
			
			[items addObject: response ];
			[response release];
		}	
	} else {
		Response *response = [[Response alloc] init];
		response.body = [results objectForKey:@"Body"];			
		
		NSDictionary *originator = [results objectForKey:@"Originator"];
		response.originator.displayName = [originator objectForKey:@"DisplayName"];
		response.originator.userReputationString = [originator objectForKey:@"UserReputationString"];				
		
		[items addObject: response ];
		[response release];		
	}

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
	static NSString *CellIdentifier2 = @"Cell2";

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
