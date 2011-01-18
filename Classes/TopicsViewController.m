    //
//  TopicsViewController.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "TopicsViewController.h"
#import "Topic.h"
#import "GTMHTTPFetcher.h"
#import "GenericTownHallAppDelegate.h"
#import "TopicCell.h"

@implementation TopicsViewController

@synthesize tableView, topics;

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
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	self.view = [[UIView alloc] initWithFrame: CGRectMake(.0f, 44.f, appDelegate.appWidth, appDelegate.appHeight)];
	[self.view setBackgroundColor:[UIColor clearColor]];	
	
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 100.f, appDelegate.appWidth, appDelegate.appHeight - 100.f) style:UITableViewStyleGrouped];
	//self.tableView.separatorColor = [UIColor clearColor];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundView:nil];
	[self.view addSubview:tableView];
	
	self.topics = [[NSMutableArray alloc] init];
	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
}


-(void)orientationChange:(NSNotification *)orientation { 
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	CGRect f = tableView.frame;
	f.size.width = appDelegate.appWidth;
	tableView.frame = f;		
	
	[tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [topics count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	Topic *topic = (Topic *)[topics objectAtIndex:indexPath.row];
	
    if (cell == nil) {
        cell = [[[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	[cell updateCellWithModel:topic];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"pass"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToTopics" object:nil userInfo:userInfo];
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
	NSLog(@"TopicsViewController dealloc");
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];		  
	[topics dealloc];
    [super dealloc];
}

-(void)fetchTopics :(NSString *) slug {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/topics/in/%@?format=json", UIAppDelegate.serverDataUrl, slug]];
	NSLog(@"Fetching topics URL: %@", url);
	
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
		NSLog(@"Fetch topics failed");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"There were no topics under the category you selected." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[alert show];
	} else {
		[topics removeAllObjects];
		
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
		
		// Create an array out of the returned json string
	    NSArray *results = [jsonString JSONValue];

		NSLog(@"Fetch topics succeeded. Count: %d", [results count]);
		
		for (NSDictionary *objectInstance in results) {
			
			Topic *topic = [Topic alloc];
			topic.name = [objectInstance objectForKey:@"Name"];
			topic.slug = [objectInstance objectForKey:@"Slug"];
			
			[topics addObject: topic];
			
		}
		[self.tableView reloadData];
		/*
		[tableView layoutIfNeeded];
		
		CGRect f = tableView.frame;
		f.size.height = [tableView contentSize].height;
		tableView.frame = f;		
		
		UITextView *textView = (UITextView*)[self.view viewWithTag: 1];
		f = textView.frame;
		f.origin.y = tableView.frame.size.height + tableView.frame.origin.y + 1.f;
		textView.frame = f;

		UIButton *button = (UIButton*)[self.view viewWithTag: 2];
		f = button.frame;		
		f.origin.y = textView.frame.size.height + textView.frame.origin.y + 1.f;
		button.frame = f;
		*/
		
	}
}

@end
