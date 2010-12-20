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
#import "AsynchImageView.h"

@implementation QuestionsViewController

@synthesize tableView, questions, currentPage, currentSlug;

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
	
	// Create the UI for this view
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 0.f, 768.f, 704.f) style:UITableViewStyleGrouped];
	self.tableView.separatorColor = [UIColor clearColor];
	[self.tableView setBackgroundView:nil];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	[self.view addSubview:self.tableView];		
	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
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
/*	NSInteger count = [questions count];
	if( count < self.currentPage * 10 ) {
		return count;
	} else {
		return count + 1;
	}
 */
	return [self.questions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if( indexPath.row < self.currentPage * 10 ) {

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
			
			UILabel *thirdLabel = [[UILabel alloc]init];
			thirdLabel.textAlignment = UITextAlignmentCenter;
			thirdLabel.font = [UIFont systemFontOfSize:20];		
			thirdLabel.textColor = [UIColor blueColor];
			thirdLabel.backgroundColor = [UIColor clearColor];
			
			UILabel *fourthLabel = [[UILabel alloc]init];
			fourthLabel.textAlignment = UITextAlignmentCenter;
			fourthLabel.font = [UIFont systemFontOfSize:9];		
			fourthLabel.textColor = [UIColor blueColor];		
			fourthLabel.backgroundColor = [UIColor clearColor];
			
			[cell.contentView addSubview:primaryLabel];
			[cell.contentView addSubview:secondaryLabel];
			[cell.contentView addSubview:thirdLabel];
			[cell.contentView addSubview:fourthLabel];
			
			CGRect frame;
			frame.size.width=50; frame.size.height=42;
			frame.origin.x=5; frame.origin.y=3;
			AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
			[asyncImage loadImageFromURL:[NSURL URLWithString:@"http://c0030282.cdn.cloudfiles.rackspacecloud.com/empty-avatar-ml.png"]];
			[cell.contentView addSubview:asyncImage];			
		}	
		
		// Set up the cell...
		//cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
		//cell.textLabel.text = [(Question *)[questions objectAtIndex:indexPath.row] subject];
		
		Question *question = (Question *)[questions objectAtIndex:indexPath.row];
		UILabel *primary = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
		UILabel *secondary = (UILabel*)[cell.contentView.subviews objectAtIndex:1];
		UILabel *third = (UILabel*)[cell.contentView.subviews objectAtIndex:2];	
		UILabel *fourth = (UILabel*)[cell.contentView.subviews objectAtIndex:3];		
		CGSize size = [question.subject sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		CGRect contentRect = cell.contentView.bounds;
		CGFloat boundsX = contentRect.origin.x;	
		
		CGRect frame = CGRectMake(boundsX+70 ,5, size.width, size.height);
		primary.frame = frame;	
		frame= CGRectMake(boundsX+70 ,frame.size.height + frame.origin.y, 500, 15);
		secondary.frame = frame;	
		frame = CGRectMake(560, 10, 50, 40);
		third.frame = frame;	
		frame = CGRectMake(5, 43, 40, 20);
		fourth.frame = frame;	
		
		primary.text = question.subject;
		secondary.text = [NSString stringWithFormat:@"Posted by %@ at %@.", question.nuggetOriginator.displayName, @"December 18, 2010"];
		third.text = [NSString stringWithFormat:@"%@", question.responseCount];
		fourth.text = [NSString stringWithFormat:@"%@ pts", question.nuggetOriginator.userReputationString];
		
		if( [indexPath row] % 2)
			[cell setBackgroundColor:[UIColor whiteColor]];
		else
			[cell setBackgroundColor:UIColorFromRGB(0xEDEDED)];
		
	}
	
	if( indexPath.row == self.currentPage * 10 ) {		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"pass"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToQuestions" object:nil userInfo:userInfo];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	// create the parent view that will hold header Label
	UIView* customView = [[[UIView alloc] init] autorelease];
	
 	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	//the button should be as big as a table view cell
	[button setFrame:CGRectMake(self.tableView.frame.size.width/2.f - 100.f, 6, 200, 30)];
	
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
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/browse/questions/in/%@/page/%d?format=json", UIAppDelegate.serverDataUrl, currentSlug, self.currentPage]];
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
			question.dateCreated = (NSString*)[objectInstance objectForKey:@"DateCreated"];
			NSDate *now = [NSDate date];
			NSLog(@"dated created %@ and now %@", question.dateCreated, now);
			

			NSDictionary *nuggetOriginator = [objectInstance objectForKey:@"NuggetOriginator"];
			question.nuggetOriginator.displayName = [nuggetOriginator objectForKey:@"DisplayName"];
			question.nuggetOriginator.userReputationString = [nuggetOriginator objectForKey:@"UserReputationString"];	
			
			[self.questions addObject: question];			
		}
		[self.tableView reloadData];		
	}
}

@end
