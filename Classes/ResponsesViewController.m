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

@synthesize curQuestion, toolbar, headerView;

- (void) loadView {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
	
    [super loadView];
	
	headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, UIAppDelegate.appWidth, 100.f)];
	[headerView setBackgroundColor:UIColorFromRGB(0xd5d8de)];
	
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
	[self.view addSubview:headerView];
	
	// add toolbar
	toolbar = [[UIToolbar alloc] init];
	[toolbar setBarStyle:UIBarStyleBlack];
	[toolbar sizeToFit];
	[toolbar setFrame: CGRectMake(0, 100.f, 768.f, 50.f)];
	
	//Add buttons
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
	
	//add array of buttons to toolbar
	[toolbar setItems:items animated:NO];
	[self.view addSubview:toolbar];	
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

- (void)viewDidAppear:(BOOL)animated {
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

	[headerView setFrame: CGRectMake(0, 0.f, appDelegate.appWidth, 100.f)];
	[toolbar setFrame: CGRectMake(0, 100.f, appDelegate.appWidth, 50.f)];
	[tableView setFrame:CGRectMake(.0f, 150.f, appDelegate.appWidth, appDelegate.appHeight - 149.f)];	
	[tableView reloadData];
}

-(void)orientationChange:(NSNotification *)orientation { 
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	CGRect f = tableView.frame;
	f.size.width = appDelegate.appWidth;
	f.size.height = appDelegate.appHeight - 149.f;	
	tableView.frame = f;		
	
	[headerView setFrame: CGRectMake(0, 0.f, appDelegate.appWidth, 150.f)];
	[toolbar setFrame: CGRectMake(0, 100.f, appDelegate.appWidth, 50.f)];
	
	[tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	// create the parent view that will hold Label
	UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0.f,0.f, appDelegate.appWidth, 50.f)] autorelease];
	[customView setBackgroundColor:[UIColor blackColor]];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(appDelegate.appWidth / 2.f - 50.f, 15.f, 100.f, 35.f)];
	[label setText:@"No entries"];
	[label setFont:[UIFont systemFontOfSize:20]];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	
	//add the button to the view
	[customView addSubview:label];
	
	if ([items count] == 0) {
		return customView;
	}
	return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 50.0;
}

- (void)dealloc {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);

    [super dealloc];
}

@end
