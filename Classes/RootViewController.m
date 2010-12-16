//
//  RootViewController.m
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "TopicsViewController.h"
#import "QuestionsViewController.h"
#import "ResponsesViewController.h"
#import "GTMHTTPFetcher.h"
#import "Category.h"
#import "Topic.h"
#import "Question.h"
#import "globals.h"
#import "GenericTownHallAppDelegate.h"


@implementation RootViewController

@synthesize detailViewController;
@synthesize topicsViewController;
@synthesize questionsViewController, responsesViewController;
@synthesize categories, currentItems;

enum {
	CategoriesView, TopicsView, QuestionsView, ResponsesView
};

NSUInteger currentView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	categories = [[NSMutableArray alloc] init];
	currentItems = [[NSMutableArray alloc] init];
	
    topicsViewController = [[TopicsViewController alloc]init];
	questionsViewController = [[QuestionsViewController alloc]init];
	responsesViewController = [[ResponsesViewController alloc]init];

	[detailViewController.view addSubview:questionsViewController.view];
	
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Microsoft Town Hall Topics"];
	navItem.hidesBackButton = YES;

	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_circle_right_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonPressed:)];
	UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right_24.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
	UIBarButtonItem *writeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(writeButtonPressed:)];
	
	backButton.enabled = YES;
    forwardButton.enabled = NO;
	
	[detailViewController.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, flexibleSpace, backButton, refreshButton, forwardButton, writeButton, nil]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToCategories:) name:@"ChangeToCategories" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToTopics:) name:@"ChangeToTopics" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToQuestions:) name:@"ChangeToQuestions" object:nil]; 
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];          	
	self.navigationItem.leftBarButtonItem = homeButton;
	
	currentView = CategoriesView;
	
	self.navigationController.navigationBar.topItem.title = @"Categories";
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/categories/all?format=json", UIAppDelegate.serverDataUrl]];
	NSLog(@"Fetching top categories URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(myFetcher:finishedWithData:error:)];
}

-(void)writeButtonPressed:(UIBarButtonItem *)button {
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(.0f, 0.f, 300.f, 400.f)];
	textView.backgroundColor = [UIColor yellowColor];
	textView.text = @"some txt";
	textView.tag = 1;

	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithFrame: CGRectMake(0,0,620, 650)];
	actionSheet.title = @"Write your question";
													
//														initWithTitle:@"Write your question" delegate:self cancelButtonTitle:@"Ok" destructiveButtonTitle:@"Cool" otherButtonTitles:nil];
	[actionSheet addSubview:textView];
	[actionSheet showInView:detailViewController.view];	
	[actionSheet release];
}

- (void)backButtonPressed:(UIBarButtonItem *)button {
	if (currentView == TopicsView) {
		//[self changeToCategories:nil];
	} else if (currentView == QuestionsView) {
		[self changeToCategories:nil];
		//[self changeToTopics:nil];
	}
}

-(void)refreshButtonPressed:(UIBarButtonItem *)button {
}


-(void)changeToCategories:(NSNotification *)pUserInfo { 
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:categories];
	[self.tableView reloadData];

	currentView = CategoriesView;
	self.navigationController.navigationBar.topItem.title = @"Categories";
	[self changeDetailsTitle:@"Questions"];
	
	[self.responsesViewController.view removeFromSuperview];
}

-(void)changeDetailsTitle:(NSString *)newTitle {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.f, 44.f)];	
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.shadowColor = UIColorFromRGB(0xe5e7eb);
	label.shadowOffset = CGSizeMake(0, 1);
	label.textColor = UIColorFromRGB(0x717880);
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.text = newTitle;
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:label];
	[label release];
	
	NSMutableArray *items = [[detailViewController.toolbar items] mutableCopy];	
	[items replaceObjectAtIndex:1 withObject:titleButton];
    [detailViewController.toolbar setItems:items animated:YES];
    [items release];
}

-(void)changeToTopics:(NSNotification *)pUserInfo { 
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:topicsViewController.topics];
	[self.tableView reloadData];
	
	currentView = TopicsView;
	self.navigationController.navigationBar.topItem.title = @"Topics";
	[self changeDetailsTitle:@"Questions"];
	
	[responsesViewController.view removeFromSuperview];
	
	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue];
	[questionsViewController fetchQuestions: [(Topic*)[currentItems objectAtIndex:pass] slug]];
	[detailViewController.view addSubview:questionsViewController.view];
	
} 


-(void)changeToQuestions:(NSNotification *)pUserInfo { 
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:questionsViewController.questions];

	[self.tableView reloadData];
	
	currentView = QuestionsView;
	self.navigationController.navigationBar.topItem.title = @"Questions";
	[self changeDetailsTitle:@"Responses"];
	
	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue];
	[responsesViewController fetchResponses: [(Question*)[currentItems objectAtIndex:pass] nuggetId]];	
	[detailViewController.view addSubview:responsesViewController.view];	
} 

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [currentItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    //cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
	
	// Discover the object inside the array, and use their appropriate property for the label
	NSObject *obj = [currentItems objectAtIndex:indexPath.row];

	if([obj class] == [Question class]) {
		cell.textLabel.text = [(Question *)[currentItems objectAtIndex:indexPath.row] subject];
	} else {
		cell.textLabel.text = [(Category *)[currentItems objectAtIndex:indexPath.row] name];
	}
	
	

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
    //detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
	//detailViewController.detailItem = 	[NSString stringWithFormat:@"%@", [categories objectAtIndex:indexPath.row]];
   
	//[categories removeObjectAtIndex:indexPath.row];
	//[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

	if(currentView == CategoriesView) {		
		//[topicsViewController fetchTopics: [(Category*)[currentItems objectAtIndex:indexPath.row] slug]];		
		[questionsViewController fetchQuestions: [(Category*)[currentItems objectAtIndex:indexPath.row] slug]];
	} else if (currentView == TopicsView) {
		[questionsViewController fetchQuestions: [(Topic*)[currentItems objectAtIndex:indexPath.row] slug]];
	} else if (currentView == QuestionsView) {
		[responsesViewController fetchResponses: [(Question*)[currentItems objectAtIndex:indexPath.row] nuggetId]];	
	}
		
}	


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[currentItems release];
	[topicsViewController release];
    [detailViewController release];
    [super dealloc];
}

- (void)myFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
	if (error != nil) {
		// failed; either an NSURLConnection error occurred, or the server returned
		// a status value of at least 300
		//
		// the NSError domain string for server status errors is kGTMHTTPFetcherStatusDomain
		int status = [error code];
		NSLog(@"Fetch failed");
	} else {
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];

		// Create an array out of the returned json string
		NSDictionary *results = [jsonString JSONValue];
		NSArray *allCategories = [results objectForKey:@"CatListModel"];
		NSLog(@"Fetch responses succeeded. Count: %d", [allCategories count]);
		
		for (NSDictionary *objectInstance in allCategories) {
			Category *cat = [Category alloc];
			cat.name = [objectInstance objectForKey:@"Name"];
			cat.slug = [objectInstance objectForKey:@"Slug"];
			cat.description = [objectInstance objectForKey:@"Description"];

			[categories addObject: cat];
		}
		[currentItems addObjectsFromArray:categories];
		[self.tableView reloadData];
	}
}




@end

