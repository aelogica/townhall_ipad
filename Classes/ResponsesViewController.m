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
#import "Response.h"

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
	
	// Create the UI for this view
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 0.f, 703.f, 704.f) style:UITableViewStylePlain];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setBackgroundView:nil];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
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
	return [self.responses count] + 1; // +1 for the header row
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
	if( indexPath.row == 0 ) {
		CGSize subjectTextsize = [currentQuestion.subject sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		CGSize bodyTextSize = [currentQuestion.body sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		NSLog(@"size on heightforRowIndexPath:%.2f", subjectTextsize.height + bodyTextSize.height + 25.f);
		return subjectTextsize.height + bodyTextSize.height + 35.f;
		
	} else {
		NSString *text = [(Response*)[self.responses objectAtIndex:indexPath.row-1] body];
		
		CGSize constraint = CGSizeMake(500.f, MAXFLOAT);
		
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		CGFloat height = MAX(size.height, 44.0f);
		
		return height + 25.f;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	
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
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			UILabel *primaryLabel = [[UILabel alloc]init];
			primaryLabel.textAlignment = UITextAlignmentLeft;
			primaryLabel.font = [UIFont systemFontOfSize:12];
			
			primaryLabel.numberOfLines = 0;
			primaryLabel.lineBreakMode = UILineBreakModeWordWrap;
			primaryLabel.backgroundColor = [UIColor clearColor];
			
			UILabel *secondaryLabel = [[UILabel alloc]init];
			secondaryLabel.textAlignment = UITextAlignmentLeft;
			secondaryLabel.font = [UIFont systemFontOfSize:9];
			secondaryLabel.backgroundColor = [UIColor clearColor];	
			secondaryLabel.textColor = UIColorFromRGB(0xdd0000);
			
			[cell.contentView addSubview:primaryLabel];
			[cell.contentView addSubview:secondaryLabel];
			[cell.contentView addSubview:[[[UILabel alloc] init] autorelease]];
			
		}		
		Response *response = (Response *)[self.responses objectAtIndex:indexPath.row - 1];
		UILabel *body = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
		UILabel *author = (UILabel*)[cell.contentView.subviews objectAtIndex:1];
		CGSize size = [response.body sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		
		CGRect frame = CGRectMake(10.f, 0.f, tableView.frame.size.width, 20.f);
		author.frame = frame;
		frame = CGRectMake(10.f, frame.origin.y + 20.f, 684.f, size.height);
		body.frame = frame;	
		
		body.text = response.body;
		author.text = [NSString stringWithFormat:@"Posted by %@ (%@ pts).", response.originator.displayName, response.originator.userReputationString];
		

		if( [indexPath row] % 2)
			[cell setBackgroundColor:[UIColor whiteColor]];
		else
			[cell setBackgroundColor:UIColorFromRGB(0xEDEDED)];
		
		return cell;
	}	
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
