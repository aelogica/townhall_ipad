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
#import "QuestionDialog.h"
#import "LoginDialog.h"
#import "ResponseDialog.h"

@implementation RootViewController

@synthesize detailViewController;
@synthesize topicsViewController;
@synthesize questionsViewController, responsesViewController;
@synthesize categories, currentItems;
@synthesize dimmer;
@synthesize oldTableView;

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

	UITableView *categoriesTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    self.tableView = categoriesTableView;	
	
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
	//UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right_24.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
	UIBarButtonItem *writeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(writeButtonPressed:)];
	UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"key_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonPressed:)];
	UIBarButtonItem *responseButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comment_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(responseButtonPressed:)];
	
	backButton.enabled = YES;
    //forwardButton.enabled = NO;
	
	[detailViewController.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, flexibleSpace, backButton, refreshButton, writeButton, loginButton, responseButton, nil]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToCategories:) name:@"ChangeToCategories" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToTopics:) name:@"ChangeToTopics" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToQuestions:) name:@"ChangeToQuestions" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dialogClose:) name:@"DialogClose" object:nil]; 	
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];          	
	self.navigationItem.leftBarButtonItem = homeButton;

	UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aelogica.png"]] autorelease];	
	self.navigationItem.titleView = logo;	
	
	currentView = CategoriesView;
	
	//self.navigationController.navigationBar.topItem.title = @"Categories";	
	
	// Initialize our dimmer view
	dimmer = [[UIView alloc] initWithFrame:CGRectMake(.0f,0.f,768.f,1024.f)];
	[dimmer setBackgroundColor:[UIColor blackColor]];
	[dimmer setAlpha:0.f];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/categories/all?format=json", UIAppDelegate.serverDataUrl]];
	NSLog(@"Fetching top categories URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(myFetcher:finishedWithData:error:)];
}

-(void)homeButtonPressed:(UIBarButtonItem *)button {
}

-(void)loginButtonPressed:(UIBarButtonItem *)button {
	// Dim the background
	[self.view.window addSubview:dimmer];
	
	LoginDialog *dialog = [[LoginDialog alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 250.f)];
	[dialog setCenter:self.view.window.center];
	[dialog setAlpha:0.f];
	[dialog setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(4.71))];
	
	[self.view.window addSubview:dialog];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.7f];
	[dimmer setAlpha:0.5f];	
	[dialog setAlpha:1.f];
	[dialog setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(1.57))];
	[UIView commitAnimations];
	[dialog release];
}


-(void)writeButtonPressed:(UIBarButtonItem *)button {
	// Dim the background
	[self.view.window addSubview:dimmer];

	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

	QuestionDialog *dialog = [[QuestionDialog alloc] initWithFrameAndQuestion:CGRectMake(0.f, 0.f, 600.f, 400.f) category:(Category *)[categories objectAtIndex:indexPath.row]];
	[dialog setCenter:self.view.window.center];
	[dialog setAlpha:0.f];
	[dialog setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(4.71))];
	
	[self.view.window addSubview:dialog];
		
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.7f];
	[dimmer setAlpha:0.5f];	
	[dialog setAlpha:1.f];
	[dialog setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(1.57))];
	[UIView commitAnimations];
	[dialog release];
}

-(void)responseButtonPressed:(UIBarButtonItem *)button {
	// Dim the background
	[self.view.window addSubview:dimmer];

	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	
	ResponseDialog *dialog = [[ResponseDialog alloc] initWithFrameAndQuestion:CGRectMake(0.f, 0.f, 600.f, 250.f) question:(Question *)[currentItems objectAtIndex:indexPath.row]];
	[dialog setCenter:self.view.window.center];
	[dialog setAlpha:0.f];
	[dialog setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(.2f, .2f), CGAffineTransformMakeRotation(4.71))];
	
	[self.view.window addSubview:dialog];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.7f];
	[dimmer setAlpha:0.5f];	
	[dialog setAlpha:1.f];
	[dialog setTransform: CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 1.f), CGAffineTransformMakeRotation(1.57))];
	[UIView commitAnimations];
	[dialog release];
}

-(void)dialogClose:(NSNotification *)pUserInfo { 
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.3f];
	[dimmer setAlpha:.0f];	
	[UIView commitAnimations];	
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

-(void)changeToCategories:(NSNotification *)pUserInfo { 
	//[questionsViewController.view removeFromSuperview];
	[self.responsesViewController.view removeFromSuperview];
	[detailViewController.view addSubview:questionsViewController.view];	
	
	//UITableView *newTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    //self.tableView = newTableView;	
	
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:categories];
	[self.tableView reloadData];

	currentView = CategoriesView;
	[self changeDetailsTitle:@"Questions"];	
}

-(void)changeToTopics:(NSNotification *)pUserInfo { 
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:topicsViewController.topics];
	[self.tableView reloadData];
	
	currentView = TopicsView;
	[self changeDetailsTitle:@"Questions"];
	
	[responsesViewController.view removeFromSuperview];
	
	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue];
	[questionsViewController fetchQuestions: [(Topic*)[currentItems objectAtIndex:pass] slug]];
	[detailViewController.view addSubview:questionsViewController.view];	
} 


-(void)changeToQuestions:(NSNotification *)pUserInfo { 
	// Remove all items and replace it with those from the questions
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:questionsViewController.questions];
	[self.tableView reloadData];	
	
	//[self.view addSubview:questionsViewController.view];
	//oldTableView = self.tableView;
	//self.tableView = questionsViewController.tableView;	
	
	// Set current root view to questions
	currentView = QuestionsView;
	[self changeDetailsTitle:@"Responses"];
	
	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue]	;
	[responsesViewController fetchResponses: (Question*)[questionsViewController.questions objectAtIndex:pass]];	

	// Show the response view controller
	[questionsViewController.view removeFromSuperview];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = UIColorFromRGB(0x104E8B);
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(15.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	headerLabel.text = @"Categories";
	[customView addSubview:headerLabel];
	
	return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 44.0;
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
		[questionsViewController.questions removeAllObjects];
		[questionsViewController setCurrentPage:1];
		[questionsViewController fetchQuestions: [(Category*)[currentItems objectAtIndex:indexPath.row] slug]];
	} else if (currentView == TopicsView) {
		[questionsViewController fetchQuestions: [(Topic*)[currentItems objectAtIndex:indexPath.row] slug]];
	} else if (currentView == QuestionsView) {
		[responsesViewController fetchResponses: (Question*)[currentItems objectAtIndex:indexPath.row]];	
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
	[categories release];
	[dimmer release];
	[topicsViewController release];
    [detailViewController release];
	[questionsViewController release];
	[responsesViewController release];
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

