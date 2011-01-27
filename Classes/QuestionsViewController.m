    //
//  QuestionsViewController.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "QuestionsViewController.h"
#import "Question.h"
#import "GTMHTTPFetcher.h"
#import "GenericTownHallAppDelegate.h"
#import "AsynchImageView.h"
#import "RootViewQuestionCell.h"
#import "DetailViewQuestionCell.h"
#import "Topic.h"
#import "LoginDialog.h"
#import "QuestionDialog.h"

@implementation QuestionsViewController

@synthesize tableView, questions, currentPage, currentQuestion, headerView, toolbar, currentTopic;

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

	questions = [[NSMutableArray alloc] init];
	currentPage = 1;
	currentSortColumn = @"date";	

	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.view setFrame:CGRectMake(.0f, 44.f, appDelegate.appWidth, appDelegate.appHeight)];
	
	headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, appDelegate.appWidth, 100.f)];
	[headerView setBackgroundColor:[UIColor blackColor]];
	
	topicName = [[UILabel alloc] initWithFrame:CGRectMake(270.f, 10.f, 200.f, 25.f)];
	topicName.font = [UIFont systemFontOfSize:20];
	topicName.backgroundColor = [UIColor clearColor];
	topicName.textColor = [UIColor redColor];
	
	UIImageView *placeholder1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_topic_bw.png"]];
	placeholder1.frame = CGRectMake(40.f, 10.f, 171.0, 77.0);									

	UIImageView *placeholder2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder2.png"]];
	placeholder2.frame = CGRectMake(500.f, 10.f, 180.0, 76.0);									

	[headerView addSubview:topicName];
	[headerView addSubview:placeholder1];
	[headerView addSubview:placeholder2];
	[self.view addSubview:headerView];
	
	// add toolbar
	toolbar = [UIToolbar new];
	[toolbar setBarStyle:UIBarStyleBlack];
	[toolbar sizeToFit];
	[toolbar setFrame: CGRectMake(0, 100.f, appDelegate.appWidth, 50.f)];
	
	//Add buttons
	UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-mostinterest-off.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonPressed:)];
	button1.tag = (NSString*)@"interest";

	UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-mostrecent-off.png"] style:UIBarButtonItemStylePlain target:self action: @selector(sortButtonPressed:)];
	button2.tag = @"date";

	UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-totalvotes-off.png"] style:UIBarButtonItemStylePlain target:self action: @selector(sortButtonPressed:)];
	button3.tag = @"votes";

	UIBarButtonItem *button4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-withresponses-off.png"] style:UIBarButtonItemStylePlain target:self action: @selector(sortButtonPressed:)];
	button4.tag = @"responses";
	
	postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post question" style:UIBarButtonItemStyleBordered target:self action:@selector(postButtonPressed:)];
	
	
	
	//Use this to put space in between your toolbox buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	//Add buttons to the array
	NSArray *items = [NSArray arrayWithObjects: flexItem, button1, button2, button3, button4, flexItem, postButton, nil];
	
	//release buttons
	[button1 release];
	[button2 release];
	[button3 release];
	[button4 release];
	//[button5 release];
	[flexItem release];
	
	//add array of buttons to toolbar
	[toolbar setItems:items animated:NO];
	[self.view addSubview:toolbar];
	
	
	// Create the UI for this view
	//[self switchTableViewStyle:UITableViewStylePlain];	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableView setBackgroundColor:UIColorFromRGB(0x3e5021)];
	[tableView setSeparatorColor: UIColorFromRGB(0x3e5021)];
	[tableView setBackgroundView:nil];
	[tableView setDataSource:self];
	[tableView setDelegate:self];	
	[self.view addSubview:self.tableView];		

	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
}

// Adjust the frame sizes of the various UI controls
- (void)viewDidAppear:(BOOL)animated {
	CGFloat rootViewWidth = self.view.superview.frame.size.width;	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	// See if this view controller is showing up on the root view pane
	if(rootViewWidth < 400.f) {
		[headerView setHidden:YES];
		[toolbar setFrame: CGRectMake(0, 0.f, self.view.superview.frame.size.width, 50.f)];
		[tableView setFrame:CGRectMake(0.f, 50.f, rootViewWidth, appDelegate.appHeight - 93.f)];
		
		// remove post question button
		NSMutableArray * items = [NSMutableArray arrayWithArray:toolbar.items];
		if([items count] == 7) {
			[items removeObjectAtIndex:6];
			[toolbar setItems:items];
		}
	}
	// Otherwise set correct frame size for the details pane
	else {
		[headerView setHidden:NO];
		[toolbar setFrame: CGRectMake(0, 100.f, self.view.superview.frame.size.width, 50.f)];
		if(appDelegate.currentOrientation == UIInterfaceOrientationPortrait || appDelegate.currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			[tableView setFrame:CGRectMake(.0f, 150.f, appDelegate.appWidth, appDelegate.appHeight - 200.f)];
		} else {
			[tableView setFrame:CGRectMake(.0f, 150.f, appDelegate.appWidth, appDelegate.appHeight - 150.f)];
		}
		NSMutableArray * items = [NSMutableArray arrayWithArray:toolbar.items];
		if([items count] == 6) {
			[items insertObject:postButton atIndex:6];
			[toolbar setItems:items];
		}
	}
	
	[tableView reloadData];
}

-(void)orientationChange:(NSNotification *)orientation { 
	NSString *o = (NSString *)[orientation object];
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

	CGRect f = tableView.frame;
	f.size.width = appDelegate.appWidth;

	if(appDelegate.currentOrientation == UIInterfaceOrientationPortrait || appDelegate.currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		f.size.height = appDelegate.appHeight - 150.f;	
	} else {
		f.size.height = appDelegate.appHeight - 200.f;	
	}
	
	
	tableView.frame = f;		
	
	[headerView setFrame: CGRectMake(0, 0.f, appDelegate.appWidth, 150.f)];
	[toolbar setFrame: CGRectMake(0, 100.f, appDelegate.appWidth, 50.f)];
	

	[tableView reloadData];
}

-(void)sortButtonPressed:(UIBarButtonItem *)button {
	currentSortColumn = (NSString*)button.tag;
	[self setCurrentPage:1];
	[questions removeAllObjects];                                           
	[self fetchQuestions: currentTopic];		
	
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
		QuestionDialog * dialog = [[QuestionDialog alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 300.f)];
		[dialog setupView:currentTopic];
		
		[dialog doAppearAnimation: self.view.window];	
		[self.view.window addSubview:dialog];
		
		
		[dialog release];
	}

}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// show an extra row at the bottom for the pagination
	NSInteger count = [questions count];
	if( count < self.currentPage * 10 ) {
		return count;
	} else {
		return count + 1;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
	static NSString *CellIdentifier3 = @"Cell3";
	
	BaseQuestionCell *cell = nil;

	CGFloat superViewWidth = self.view.superview.frame.size.width;	

	if( indexPath.row < self.currentPage * 10 ) {
		Question *question = (Question *)[questions objectAtIndex:indexPath.row];

		// Depending on the current view, if the questions are showing up on the detail pane it will have larger width
		if (superViewWidth > 400.f) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];	
			if (cell == nil) {					
				cell = [[[DetailViewQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			}	
		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];	
			if (cell == nil) {					
				cell = [[[RootViewQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
			}
		}				

		[cell updateCellWithQuestion:question];
	} else {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
	
		UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 768.f, 50.f)];
		[backgroundView setBackgroundColor:[UIColor blackColor]];
		cell.backgroundView = backgroundView;
		
		UIView *selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		selectedBackgroundView.backgroundColor = UIColorFromRGB(0x93c843);
		selectedBackgroundView.alpha = 0.3f;	
		selectedBackgroundView.opaque = NO;
		cell.selectedBackgroundView = selectedBackgroundView;		
		
		CGRect labelFrame = CGRectMake(self.tableView.frame.size.width/2.f - 100.f, 12.f, 200.f, 25.f);
		UILabel *label = [[UILabel alloc] init];
		[label setFrame:labelFrame];
		[label setFont:[UIFont systemFontOfSize:16]];
		[label setTextColor:[UIColor whiteColor]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setText:@"Load more"];
		[backgroundView addSubview:label];
		[label release];		
		
		UILabel *selectedBackgroundLabel = [[UILabel alloc] init];
		[selectedBackgroundLabel setFrame:labelFrame];
		[selectedBackgroundLabel setFont:[UIFont systemFontOfSize:16]];
		[selectedBackgroundLabel setTextColor:[UIColor whiteColor]];
		[selectedBackgroundLabel setBackgroundColor:[UIColor clearColor]];
		[selectedBackgroundLabel setText:@"Load more"];
		[selectedBackgroundView addSubview:selectedBackgroundLabel];
		[selectedBackgroundLabel release];		
		
	}

	cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if( indexPath.row < self.currentPage * 10 ) {
	NSString *text = [(Question*)[self.questions objectAtIndex:indexPath.row] subject];
	
	CGSize constraint = CGSizeMake(500.f, MAXFLOAT);
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat height = MAX(size.height, 55.0f);
	
	return 105.f;
	} else {
		return 50.f;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if( indexPath.row < self.currentPage * 10 ) {

		currentQuestion = [questions objectAtIndex:indexPath.row];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToQuestions" object:nil userInfo:userInfo];
	} else {
		self.currentPage++;
		[self fetchQuestions: currentTopic];
	}
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
	
	if ([questions count] == 0) {
		return customView;
	}
	return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 50.0;
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
	NSLog(@"QuestionsViewController dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];	  
	[tableView dealloc];
	[toolbar dealloc];
	[postButton dealloc];
	[topicName dealloc];
    [super dealloc];
}

-(void)showMorePressed:(UIButton *)button {
	self.currentPage++;
	[self fetchQuestions: currentTopic];
}



-(void)fetchQuestions :(Topic *) aTopic {
	currentTopic = aTopic;
	topicName.text = currentTopic.name;

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/browse/questions/in/%@/page/%d?format=json&sortKey=%@", 
						UIAppDelegate.serverDataUrl, currentTopic.slug, currentPage, currentSortColumn]];
	NSLog(@"Fetching questions URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:error:)];	
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD showUsingAnimation:YES];
}

- (NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    //NSLog(@"%llu",milliseconds);
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
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
		//[questions removeAllObjects];
		
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
		
		// Create an array out of the returned json string
	    NSArray *results = [jsonString JSONValue];
		
		NSLog(@"Fetch questions succeeded. Count: %d", [results count]);
		
		for (NSDictionary *objectInstance in results) {
			
			Question *question = [[Question alloc] init];
			question.subject = [objectInstance objectForKey:@"Subject"];
			question.body = [objectInstance objectForKey:@"Body"];
			question.nuggetId = [objectInstance objectForKey:@"NuggetID"];
			question.responseCount = [objectInstance objectForKey:@"ResponseCount"];
			question.dateCreated = [self getDateFromJSON:[objectInstance objectForKey:@"DateCreated"]];

			NSDictionary *nuggetOriginator = [objectInstance objectForKey:@"NuggetOriginator"];
			question.nuggetOriginator.userId = [nuggetOriginator objectForKey:@"UserID"];
			question.nuggetOriginator.displayName = [nuggetOriginator objectForKey:@"DisplayName"];
			question.nuggetOriginator.userReputationString = [nuggetOriginator objectForKey:@"UserReputationString"];	
			question.nuggetOriginator.avatar = [nuggetOriginator objectForKey:@"Avatar"];			
			
			NSDictionary *votesDict = [objectInstance objectForKey:@"Votes"];
			question.votes.upVotes = [(NSNumber*)[votesDict objectForKey:@"UpVotes"] stringValue];	
			question.votes.upPercentage = [(NSNumber*)[votesDict objectForKey:@"UpPercentage"] stringValue];	
			question.votes.downVotes = [(NSNumber*)[votesDict objectForKey:@"downVotes"] stringValue];	
			question.votes.downPercentage = [(NSNumber*)[votesDict objectForKey:@"DownPercentage"] stringValue];	
			
			[self.questions addObject: question];			
		}
		[self.tableView reloadData];		
	}
}

@end
