    //
//  ResponsesViewController.m
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResponsesViewController.h"
#import "GTMHTTPFetcher.h"
#import "GenericTownHallAppDelegate.h"
#import "Question.h"
#import "ResponseCell.h"
#import "Response.h"
#import <QuartzCore/QuartzCore.h>

@implementation ResponsesViewController
@synthesize tableView, responses, currentQuestion;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.responses = [[NSMutableArray alloc] init];

	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.view setFrame:CGRectMake(.0f, 44.f, 768.f, 1004.f)];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 768.f, 100.f)];
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
	UIToolbar *toolbar = [UIToolbar new];
	[toolbar setBarStyle:UIBarStyleBlack];
	[toolbar sizeToFit];
	[toolbar setFrame: CGRectMake(0, 100.f, 768.f, 50.f)];
	
	//Add buttons
	UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Responses" 
																style:UIBarButtonItemStylePlain target:nil action:nil];
	
	UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"Post response" 
																style:UIBarButtonItemStyleBordered target:self action:nil];
	
	
	
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
	
	
	// Create the UI for this view
	//[self switchTableViewStyle:UITableViewStylePlain];	
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 150.f, 768.f, 804.f) style:UITableViewStylePlain];
	[tableView setBackgroundColor:UIColorFromRGB(0x3e5021)];
	[tableView setSeparatorColor: UIColorFromRGB(0x3e5021)];
	[tableView setBackgroundView:nil];
	[tableView setDataSource:self];
	[tableView setDelegate:self];	
	[self.view addSubview:tableView];		
}

#pragma mark Event listener methods

- (void)backButtonPressed:(UIBarButtonItem *)button {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToTopics" object:nil userInfo:nil];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.responses count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
	/*
	if( indexPath.row == 0 ) {
		CGSize subjectTextsize = [currentQuestion.subject sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		CGSize bodyTextSize = [currentQuestion.body sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		NSLog(@"size on heightforRowIndexPath:%.2f", subjectTextsize.height + bodyTextSize.height + 25.f);
		return subjectTextsize.height + bodyTextSize.height + 35.f;
		
	} else {
		 */
		NSString *text = [(Response*)[self.responses objectAtIndex:indexPath.row] body];
		
		CGSize constraint = CGSizeMake(500.f, MAXFLOAT);
		
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		CGFloat height = MAX(size.height, 44.0f);
		
		return 105.f;
	//}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	/*
	if( indexPath.row == 0 ) {
		// Construct the header
		CGSize subjectTextsize = [currentQuestion.subject sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		CGSize bodyTextSize = [currentQuestion.body sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
			
			UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, tableView.frame.size.width, 200.f)];
			[customView setBackgroundColor:UIColorFromRGB(0x8DB6CD)];			
			
			// create the button object
			UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.0, cell.contentView.frame.size.width, subjectTextsize.height)];
			subjectLabel.backgroundColor = [UIColor clearColor];
			subjectLabel.numberOfLines = 0;
			subjectLabel.lineBreakMode = UILineBreakModeWordWrap;
			subjectLabel.textColor = UIColorFromRGB(0x104E8B);
			subjectLabel.font = [UIFont systemFontOfSize:15];
			
			UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, subjectLabel.frame.origin.y + subjectLabel.frame.size.height, tableView.frame.size.width, 20.f)];
			authorLabel.backgroundColor = [UIColor clearColor];
			authorLabel.textColor = UIColorFromRGB(0xCD0000);
			authorLabel.font = [UIFont systemFontOfSize:12];
			
			UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, authorLabel.frame.origin.y + authorLabel.frame.size.height + 10.f, tableView.frame.size.width, bodyTextSize.height)];
			bodyLabel.backgroundColor = [UIColor whiteColor];
			bodyLabel.numberOfLines = 0;
			bodyLabel.lineBreakMode = UILineBreakModeWordWrap;
			bodyLabel.opaque = NO;
			bodyLabel.font = [UIFont systemFontOfSize:15];

			bodyLabel.textAlignment = UITextAlignmentLeft;
			
			[customView addSubview:subjectLabel];	
			[customView addSubview:authorLabel];	
			[cell.contentView addSubview:customView];
			[cell.contentView addSubview:bodyLabel];
			
			[subjectLabel release];
			[authorLabel release];
			[bodyLabel release];
		}
		UIView *customView = (UIView*)[cell.contentView.subviews objectAtIndex:0];
		[customView setFrame:CGRectMake(.0f, .0f, tableView.frame.size.width, subjectTextsize.height + bodyTextSize.height + 24.f)];
		
		UILabel *subject = (UILabel*)[customView.subviews objectAtIndex: 0];
		UILabel *author = (UILabel*)[customView.subviews objectAtIndex:1];
		UILabel *body = (UILabel*)[cell.contentView.subviews objectAtIndex:1];		

		CGRect frame = CGRectMake(15.f, 4.f, cell.contentView.frame.size.width, subjectTextsize.height);
		subject.frame = frame;
		frame = CGRectMake(15.f ,frame.size.height + frame.origin.y, tableView.frame.size.width, 20.f);
		author.frame = frame;
		frame = CGRectMake(0.f ,frame.size.height + frame.origin.y + 10.f, tableView.frame.size.width, bodyTextSize.height);
		body.frame = frame;
		
		author.text = [NSString stringWithFormat:@"Posted by %@ at %@ (%@ pts).", currentQuestion.nuggetOriginator.displayName, @"December 18, 2010", currentQuestion.nuggetOriginator.userReputationString];
		subject.text = currentQuestion.subject;
		body.text = currentQuestion.body;
		
		//[cell setFrame:CGRectMake(.0f, .0f, tableView.frame.size.width, subjectTextsize.height + bodyTextSize.height + 24.f)];
		return cell;

	} else {
	 */
		ResponseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if (cell == nil) {
			cell = [[[ResponseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
		}	
	
		Response *response = (Response *)[self.responses objectAtIndex:indexPath.row];
		[cell updateCellWithModel:response];		
		

		if( [indexPath row] % 2)
			[cell setBackgroundColor:[UIColor whiteColor]];
		else
			[cell setBackgroundColor:UIColorFromRGB(0xEDEDED)];
		
		return cell;
	//}	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)fetchResponses :(Question *) question {
	currentQuestion = question;
	
	UIView *headerView = (UIView*)[self.view.subviews objectAtIndex:0];
	UILabel *subject = (UILabel*)[headerView.subviews objectAtIndex:0];
	UILabel *author = (UILabel*)[headerView.subviews objectAtIndex:1];
	subject.text = currentQuestion.body;
	author.text = [NSString stringWithFormat:@"    Posted by %@ at %@ (%@ pts).", currentQuestion.nuggetOriginator.displayName, currentQuestion.dateCreatedFormatted, currentQuestion.nuggetOriginator.userReputationString];
	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/questions/%@?format=json", UIAppDelegate.serverDataUrl, currentQuestion.nuggetId]];
	NSLog(@"Fetching responses URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:error:)];	
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD showUsingAnimation:YES];
}

- (void)myFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD hideUsingAnimation:YES];
	
	if (error != nil) {
		// failed; either an NSURLConnection error occurred, or the server returned
		// a status value of at least 300
		//
		// the NSError domain string for server status errors is kGTMHTTPFetcherStatusDomain
		int status = [error code];
		NSLog(@"Fetch responses failed");
	} else {
		[self.responses removeAllObjects];
		
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
		
		// Create an array out of the returned json string
	    NSDictionary *results = [jsonString JSONValue];
		NSArray *allResponses = [results objectForKey:@"Responses"];
		NSLog(@"Fetch responses succeeded. Count: %d", [allResponses count]);
		
		for (NSDictionary *objectInstance in allResponses) {
			Response *response = [[Response alloc] init];
			response.body = [objectInstance objectForKey:@"Body"];			

			NSDictionary *originator = [objectInstance objectForKey:@"Originator"];
			response.originator.displayName = [originator objectForKey:@"DisplayName"];
			response.originator.userReputationString = [originator objectForKey:@"UserReputationString"];				
			
			[self.responses addObject: response ];
			[response release];
		}
		[self.tableView reloadData];
			
	}
}


@end
