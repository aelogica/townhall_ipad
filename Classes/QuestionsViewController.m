    //
//  QuestionsViewController.m
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuestionsViewController.h"
#import "Question.h"
#import "GTMHTTPFetcher.h"
#import "GenericTownHallAppDelegate.h"

@implementation QuestionsViewController

@synthesize tableView, questions;

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
	
	self.questions = [[NSMutableArray alloc] init];
	
	[self.view setFrame:CGRectMake(.0f, 44.f, 768.f, 1004.f)];
	
	// Create the UI for this view
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 0.f, 703.f, 126.f) style:UITableViewStyleGrouped];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundColor:[UIColor purpleColor]];
	[self.view addSubview:tableView];	
	
	// Create textview and put right after the table view
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(.0f, tableView.frame.size.height + tableView.frame.origin.y + 1.f, tableView.frame.size.width, 200.f)];
	textView.backgroundColor = [UIColor yellowColor];
	textView.text = @"some txt";
	textView.tag = 1;
	//[self.view addSubview:textView];
	
	// Create submit button after the text view
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];	
	button.frame = CGRectMake(.0f, textView.frame.size.height + textView.frame.origin.y + 1.f, 100.f, 30.f);
	[button setTitle:@"Submit" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	button.tag = 2;
	//[self.view addSubview:button];
	
	UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];	
	button2.frame = CGRectMake(.0f, button.frame.size.height + button.frame.origin.y + 1.f, 100.f, 30.f);
	[button2 setTitle:@"Login" forState:UIControlStateNormal];
	[button2 addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	button2.tag = 3;
	//[self.view addSubview:button2];	
	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
}


#pragma mark Event listener methods


-(void)loginButtonPressed {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/account/authenticate?format=xml", UIAppDelegate.serverBaseUrl]];	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = @"username=mickey&password=karen143";  
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: postData];
	
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(postRequestHandler:finishedWithData:error:)];	
}

-(void)submitButtonPressed {
	NSString *slug = @"stem";
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/questions/in/%@/create", UIAppDelegate.serverDataUrl, slug]];	
	NSLog(@"Posting a question to Url: %@", url);
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = @"body=val1&tags=val2&categorySlug=stem";  
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: postData];
	
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(postRequestHandler:finishedWithData:error:)];	
}

-(void)orientationChange:(NSNotification *)orientation { 
	NSString *o = (NSString *)[orientation object];
	
	CGRect f = tableView.frame;
	if(o == @"Portrait") {		
		f.size.width = 768.f;		
	} else {		
		f.size.width = 703.f;
	}
	tableView.frame = f;		
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.questions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Set up the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	cell.textLabel.text = [(Question *)[questions objectAtIndex:indexPath.row] subject];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"pass"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToQuestions" object:nil userInfo:userInfo];
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


-(void)fetchQuestions :(NSString *) slug {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/browse/questions/in/%@?format=json", UIAppDelegate.serverDataUrl, slug]];
	NSLog(@"Fetching questions URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:error:)];	
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD showUsingAnimation:YES];
}

- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
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
		NSLog(@"Fetch questions failed");
	} else {
		[questions removeAllObjects];
		
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
		
		// Create an array out of the returned json string
	    NSArray *results = [jsonString JSONValue];
		
		NSLog(@"Fetch questions succeeded. Count: %d", [results count]);
		
		for (NSDictionary *objectInstance in results) {
			
			Question *question = [Question alloc];
			question.subject = [objectInstance objectForKey:@"Subject"];
			question.body = [objectInstance objectForKey:@"Body"];
			question.nuggetId = [objectInstance objectForKey:@"NuggetID"];
			
			[self.questions addObject: question];
			
		}
		[self.tableView reloadData];		
		
		// Adjust table view height
		CGRect f = tableView.frame;
		f.size.height = [tableView contentSize].height;
		tableView.frame = f;		
		
	}
}

@end
