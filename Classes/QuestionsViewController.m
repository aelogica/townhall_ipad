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
#import "QuestionGroupedCell.h"
#import "QuestionPlainCell.h"
#import "AsynchImageView.h"
#import "DetailQuestionCell.h"

@implementation QuestionsViewController

@synthesize tableView, questions, currentPage, currentSlug, currentQuestion;

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
	self.currentPage = 1;

	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.view setFrame:CGRectMake(.0f, 44.f, 768.f, 1004.f)];
	
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 768.f, 100.f)];
	[headerView setBackgroundColor:[UIColor blackColor]];
	
	UILabel *categoryName = [[UILabel alloc] initWithFrame:CGRectMake(270.f, 10.f, 200.f, 25.f)];
	categoryName.text = @"Motorcycle Category";
	categoryName.font = [UIFont systemFontOfSize:20];
	categoryName.backgroundColor = [UIColor clearColor];
	categoryName.textColor = [UIColor redColor];
	
	UIImageView *placeholder1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_topic_bw.png"]];
	placeholder1.frame = CGRectMake(40.f, 10.f, 171.0, 77.0);									

	UIImageView *placeholder2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder2.png"]];
	placeholder2.frame = CGRectMake(540.f, 10.f, 180.0, 76.0);									

	[headerView addSubview:categoryName];
	[headerView addSubview:placeholder1];
	[headerView addSubview:placeholder2];
	[self.view addSubview:headerView];
	
	// add toolbar
	UIToolbar *toolbar = [UIToolbar new];
	[toolbar setBarStyle:UIBarStyleBlack];
	[toolbar sizeToFit];
	[toolbar setFrame: CGRectMake(0, 100.f, 768.f, 50.f)];
	
	//Add buttons
	UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-mostinterest-off.png"] 
																	style:UIBarButtonItemStylePlain target:self 
																   action: nil];

	UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-mostrecent-off.png"] 
																	style:UIBarButtonItemStylePlain target:self 
																   action: nil];

	UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-totalvotes-off.png"] 
																	style:UIBarButtonItemStylePlain target:self 
																   action: nil];

	UIBarButtonItem *button4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-withresponses-off.png"] 
																	style:UIBarButtonItemStylePlain target:self 
																   action: nil];
	
	
	//Use this to put space in between your toolbox buttons
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	//Add buttons to the array
	NSArray *items = [NSArray arrayWithObjects: flexItem, button1, button2, button3, button4, flexItem, nil];
	
	//release buttons
	[button1 release];
	[button2 release];
	[button3 release];
	[button4 release];
	[flexItem release];
	
	//add array of buttons to toolbar
	[toolbar setItems:items animated:NO];
	[self.view addSubview:toolbar];
	
	
	// Create the UI for this view
	//[self switchTableViewStyle:UITableViewStylePlain];	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 150.f, 768.f, 804.f) style:UITableViewStylePlain];
	[tableView setBackgroundColor:UIColorFromRGB(0x3e5021)];
	[tableView setSeparatorColor: UIColorFromRGB(0x3e5021)];
	[tableView setBackgroundView:nil];
	[tableView setDataSource:self];
	[tableView setDelegate:self];	
	[self.view addSubview:self.tableView];		

	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
}
	 
-(void)switchTableViewStyle:(UITableViewStyle)style {
	/*
	[self.tableView removeFromSuperview];
	[self.tableView release];

	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 0.f, 703.f, 704.f) style:style];
	self.tableView.separatorColor = [UIColor clearColor];
	[self.tableView setBackgroundView:nil];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];	
	[self.view addSubview:self.tableView];		
	 */
}

-(void)orientationChange:(NSNotification *)orientation { 
	NSString *o = (NSString *)[orientation object];
	
	CGRect f = tableView.frame;
	if(o == @"Portrait") {		
		f.size.width = 768.f;		
		f.size.height = 960.f;
	} else {		
		f.size.width = 703.f;
		f.size.height = 704.f;
	}
	tableView.frame = f;		
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
	
	BaseQuestionCell *cell = nil;

	// Depending on the current view, if the questions are showing up on the left side it will be using UITableViewStylePlain
	/*
	if(self.tableView.style == UITableViewStyleGrouped) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];	
		if (cell == nil) {					
			cell = [[[QuestionGroupedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
			
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];	

		if (cell == nil) {					
			cell = [[[QuestionPlainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
		}
		
	}*/
	
	if( indexPath.row < self.currentPage * 10 ) {
		Question *question = (Question *)[questions objectAtIndex:indexPath.row];

		if (cell == nil) {					
			cell = [[[DetailQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}		

		[cell updateCellWithQuestion:question];
	} else {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
	
		UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 768.f, 60.f)];
		[backgroundView setBackgroundColor:[UIColor blackColor]];
		cell.backgroundView = backgroundView;
		
		UILabel *label = [[UILabel alloc] init];
		[label setFrame:CGRectMake(self.tableView.frame.size.width/2.f - 100.f, 12.f, 200.f, 30.f)];
		[label setFont:[UIFont systemFontOfSize:16]];
		[label setTextColor:[UIColor whiteColor]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setText:@"Load more"];
		[backgroundView addSubview:label];
		[label release];		
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
		return 60.f;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if( indexPath.row < self.currentPage * 10 ) {

		currentQuestion = [questions objectAtIndex:indexPath.row];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"pass"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToQuestions" object:nil userInfo:userInfo];
	} else {
		self.currentPage++;
		[self fetchQuestions: currentSlug];
	}
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] init] autorelease];
	
 	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//the button should be as big as a table view cell
	if(tableView.style == UITableViewStyleGrouped) {
		[button setFrame:CGRectMake(self.tableView.frame.size.width/2.f - 100.f, 6.f, 200.f, 30.f)];
	} else {
		[button setFrame:CGRectMake(20.f, 6.f, 200.f, 30.f)];
	}
	
	//set title, font size and font color
	[button setTitle:@"Show next 10 questions" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(showMorePressed:) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[customView addSubview:button];
	
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 40.0;
}
*/

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

-(void)showMorePressed:(UIButton *)button {
	self.currentPage++;
	[self fetchQuestions: currentSlug];
}



-(void)fetchQuestions :(NSString *) slug {
	currentSlug = slug;	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/browse/questions/in/%@/page/%d?format=json&sortKey=date", UIAppDelegate.serverDataUrl, currentSlug, self.currentPage]];
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
    NSLog(@"%llu",milliseconds);
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
			//NSDate *now = [NSDate date];
			NSLog(@"dated created %@", question.dateCreated);
			

			NSDictionary *nuggetOriginator = [objectInstance objectForKey:@"NuggetOriginator"];
			question.nuggetOriginator.userId = [nuggetOriginator objectForKey:@"UserID"];
			question.nuggetOriginator.displayName = [nuggetOriginator objectForKey:@"DisplayName"];
			question.nuggetOriginator.userReputationString = [nuggetOriginator objectForKey:@"UserReputationString"];	
			question.nuggetOriginator.avatar = [nuggetOriginator objectForKey:@"Avatar"];			
			
			NSDictionary *votesDict = [objectInstance objectForKey:@"Votes"];
			question.votes.upVotes = [(NSNumber*)[votesDict objectForKey:@"UpVotes"] stringValue];	
			question.votes.upPercentage = [(NSNumber*)[votesDict objectForKey:@"UpPercentage"] stringValue];	
			NSLog(question.votes.upPercentage);
			question.votes.downVotes = [(NSNumber*)[votesDict objectForKey:@"downVotes"] stringValue];	
			question.votes.downPercentage = [(NSNumber*)[votesDict objectForKey:@"DownPercentage"] stringValue];	
			
			[self.questions addObject: question];			
		}
		[self.tableView reloadData];		
	}
}

@end
