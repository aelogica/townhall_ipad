//
//  RootViewController.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "RootViewController.h"
#import "DetailViewController.h"
#import "CategoriesViewController.h"
#import "TopicsViewController.h"
#import "QuestionsViewController.h"
#import "ResponsesViewController.h"
#import "ProfileViewController.h"
#import "GTMHTTPFetcher.h"
#import "Category.h"
#import "Topic.h"
#import "Question.h"
#import "globals.h"
#import "GenericTownHallAppDelegate.h"
#import "BaseDialog.h"
#import "QuestionDialog.h"
#import "LoginDialog.h"
#import "ResponseDialog.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "FBConnect/FBConnect.h"

#import "TwitterView.h"


@implementation RootViewController

@synthesize detailViewController;
@synthesize categoriesViewController;
@synthesize topicsViewController;
@synthesize questionsViewController, responsesViewController, profileViewController;
@synthesize categories, currentItems;
@synthesize dimmer;
@synthesize oldTableView;
@synthesize loginButton, logoutButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.currentOrientation = [[UIDevice currentDevice] orientation];
	
	//[appDelegate.progressHUD hideUsingAnimation:YES];
	
	
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	switch (orientation) {
        case UIInterfaceOrientationPortrait:		
        case UIInterfaceOrientationPortraitUpsideDown:
			appDelegate.appWidth = 768.f;
			appDelegate.appHeight = 1004.f;
			NSLog(@"Orientation is portrait");
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			appDelegate.appWidth = 703.f;
			appDelegate.appHeight = 748.f;
			NSLog(@"Orientation is landscape");
			break;
		default:
			appDelegate.appWidth = 768.f;
			appDelegate.appHeight = 1004.f;
			appDelegate.currentOrientation = UIInterfaceOrientationPortrait;
			NSLog(@"Orientation not detected");
			break;
    }
	
	UIView *backgroundView = [[UIView alloc] initWithFrame: self.view.frame];
	backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-tile.png"]];
	[self.view addSubview:backgroundView];
	[backgroundView release];
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-tile.png"]];
	
	UITableView *categoriesTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 1000.f) style:UITableViewStyleGrouped] autorelease];
	categoriesTableView.backgroundColor = [UIColor clearColor];
    self.tableView = categoriesTableView;	
	
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	categories = [[NSMutableArray alloc] init];
	currentItems = [[NSMutableArray alloc] init];

    categoriesViewController = [[CategoriesViewController alloc]init];
    topicsViewController = [[TopicsViewController alloc]init];
	questionsViewController = [[QuestionsViewController alloc]init];
	responsesViewController = [[ResponsesViewController alloc]init];
	profileViewController = [[ProfileViewController alloc]init];

	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_circle_right_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonPressed:)];

	loginButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"key_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonPressed:)];
	logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed:)];
	
	UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"man_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonPressed:)];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120.f, 44.f)];	
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.shadowColor = UIColorFromRGB(0xe5e7eb);
	label.shadowOffset = CGSizeMake(0, 1);
	label.textColor = UIColorFromRGB(0x717880);
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.text = @"Categories";
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:label];
	[label release];
	
	[detailViewController.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, titleButton, flexibleSpace, backButton, refreshButton, nil]];
	[titleButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToCategories:) name:@"ChangeToCategories" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToTopics:) name:@"ChangeToTopics" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToQuestions:) name:@"ChangeToQuestions" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dialogClose:) name:@"DialogClose" object:nil]; 	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess:) name:@"UserLoginSuccess" object:nil]; 	
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];          	
	self.navigationItem.leftBarButtonItem = homeButton;

	self.navigationItem.title = @"";
	
	appDelegate.currentView = CategoriesView;
	
	//self.navigationController.navigationBar.topItem.title = @"Categories";	

	
	// Set to categories view on launch app
	[detailViewController.view addSubview:categoriesViewController.view];
	[flexibleSpace release];
	[backButton release];
	[refreshButton release];
	[profileButton release];	
	
}

-(void)homeButtonPressed:(UIBarButtonItem *)button {
	[self changeToHome];
}

-(void)loginButtonPressed:(UIBarButtonItem *)button {
	LoginDialog *dialog = [[LoginDialog alloc] initWithFrame:CGRectMake(0.f, 20.f, 600.f, 250.f)];
	[dialog setupView:nil];
	[dialog doAppearAnimation: self.view.window];	
	[self.view.window addSubview:dialog];
	[dialog release];
}

-(void)logoutButtonPressed:(UIBarButtonItem *)button {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/account/logoff", UIAppDelegate.serverDataUrl]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	[request setHTTPMethod:@"GET"];
	
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(logoutRequestHandler:finishedWithData:error:)];	   	
}

- (void)logoutRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
	NSMutableArray * items = [NSMutableArray arrayWithArray:detailViewController.toolbar.items];
	[items removeLastObject];
	//[items replaceObjectAtIndex:5  withObject:loginButton];
	[detailViewController.toolbar setItems:items];
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.isLogin = NO;	
}


-(void)profileButtonPressed:(UIBarButtonItem *)button {
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"Sorry feature unavaialble yet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    [alert show];
	//[detailViewController.view addSubview:profileViewController.view];
}

-(void)dialogClose:(NSNotification *)pUserInfo { 
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.3f];
	[dimmer setAlpha:.0f];	
	[UIView commitAnimations];	
}

- (void)backButtonPressed:(UIBarButtonItem *)button {
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	if(appDelegate.currentView == CategoriesView) {
		[self changeToHome];
	} else if (appDelegate.currentView == TopicsView) {
		[self changeToCategories:nil];
	} else if (appDelegate.currentView == QuestionsView) {
		[self changeToTopics:nil];
	}
}

-(void)refreshButtonPressed:(UIBarButtonItem *)button {
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	if(appDelegate.currentView == CategoriesView) {	
		//[self changeToTopics:nil];
	} else if( appDelegate.currentView == TopicsView) {
		[questionsViewController setCurrentPage:1];
		[questionsViewController.items removeAllObjects];                                           
		//[questionsViewController fetchQuestions: questionsViewController.currentTopic];		
		UIAppDelegate.currentSlug = questionsViewController.curTopic;
		[questionsViewController makeHttpRequest];
	}
	else if( appDelegate.currentView == QuestionsView) {
		//[responsesViewController fetchResponses:questionsViewController.currentQuestion];	
		responsesViewController.curQuestion = questionsViewController.currentQuestion;	
		[responsesViewController makeHttpRequest];

	}
}

-(void)userLoginSuccess:(NSNotification *)pUserInfo { 
	NSMutableArray * items = [NSMutableArray arrayWithArray:detailViewController.toolbar.items];
	//[items replaceObjectAtIndex:5  withObject:logoutButton];
	[items addObject:logoutButton];
	[detailViewController.toolbar setItems:items];
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.isLogin = YES;
}


-(void)changeDetailsRootButtonTitle:(NSString *)newTitle {
	UIToolbar *toolbar = [detailViewController toolbar];
	NSMutableArray *items = [[toolbar items] mutableCopy];
	UIBarButtonItem *barButtonItem = [items objectAtIndex:0];
	[barButtonItem setTitle:newTitle];
    [items replaceObjectAtIndex:0 withObject:barButtonItem];
    [toolbar setItems:items animated:YES];
    [items release];	
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.currentBarButtonTitle = newTitle;	
}

	
-(void)changeDetailsTitle:(NSString *)newTitle {

	NSMutableArray *items = [[detailViewController.toolbar items] mutableCopy];	
	
	int index = 1;
	if(items.count == 6) {
		index = 2;
	}
	
	UIBarButtonItem *barButtonItem = [items objectAtIndex:index];
	UILabel *customView = (UILabel*)[barButtonItem customView];
	[customView setText:newTitle];
	[barButtonItem setCustomView:customView];
	[items replaceObjectAtIndex:index withObject:barButtonItem];			
    [detailViewController.toolbar setItems:items animated:YES];

    [items release];
	
}

-(void)changeToHome {
	[currentItems removeAllObjects];
	[self.tableView reloadData];
	
	// remove all view controllers except the categories view controller
	[responsesViewController.view removeFromSuperview];
	[questionsViewController.view removeFromSuperview];
	[topicsViewController.view removeFromSuperview];
	[profileViewController.view removeFromSuperview];
	
	[self changeDetailsTitle:@"Categories"];

	[detailViewController.view addSubview:categoriesViewController.view];
}

-(void)changeToCategories:(NSNotification *)pUserInfo { 
	[categoriesViewController.view removeFromSuperview];
	[responsesViewController.view removeFromSuperview];
	[questionsViewController.view removeFromSuperview];
	
	//UITableView *newTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    //self.tableView = newTableView;	
	
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:categoriesViewController.items];
	[self.tableView reloadData];
	
	// Make sure the selected row stays highlighted
	NSIndexPath *indexPath = [categoriesViewController.tableView indexPathForSelectedRow];
	[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	int index = [[[pUserInfo userInfo] valueForKey:@"index"] intValue];
	Category *category = (Category*)[categoriesViewController.items objectAtIndex:index];
	appDelegate.currentSlug = [category slug];
	[topicsViewController makeHttpRequest];
	[detailViewController.view addSubview:topicsViewController.view];	


	appDelegate.currentView = CategoriesView;	
	[self changeDetailsTitle:@"Topics"];
	[self changeDetailsRootButtonTitle:[category name]];
}

-(void)changeToTopics:(NSNotification *)pUserInfo { 
	// clear out all items from the root list
	[currentItems removeAllObjects];
	// then fill it up with the topic items
	[currentItems addObjectsFromArray:topicsViewController.items];
	// reload the data to reflect the new items
	[self.tableView reloadData];

	// set the root view to topics
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.currentView = TopicsView;
	// change the title of the details view pane 
	[self changeDetailsTitle:@"Questions"];
	
	// remove both topics and response view controller
	// user may be coming from the response view hence its included
	[topicsViewController.view removeFromSuperview];
	[responsesViewController.view removeFromSuperview];
	
	// highlight the selected row on the root list
	NSIndexPath *indexPath = [topicsViewController.tableView indexPathForSelectedRow];
	[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

	// set the question view back to page 1
	[questionsViewController setCurrentPage:1];

	// clear out the questions, we're starting from page 1
	[questionsViewController.items removeAllObjects];	
	Topic *topic = (Topic*)[currentItems objectAtIndex:indexPath.row];
	// now fetch the new questions
	questionsViewController.curTopic = topic;
	[questionsViewController makeHttpRequest];
	//[questionsViewController fetchQuestions: topic];

	// and then we add the question view to the detail view
	[detailViewController.view addSubview:questionsViewController.view];	
	[questionsViewController viewDidAppear:NO];
	
	// and go ahead and change the root button bar title
	[self changeDetailsRootButtonTitle:[topic name]];
} 


-(void)changeToQuestions:(NSNotification *)pUserInfo { 
	// Remove all items and replace it with those from the questions
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:questionsViewController.items];
	[self.tableView reloadData];	
	
	[self.view addSubview:questionsViewController.view];	
	[questionsViewController viewDidAppear:NO];
/*
	NSIndexPath *indexPath = [questionsViewController.tableView indexPathForSelectedRow];
	[questionsViewController.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
*/	
	int index = [[[pUserInfo userInfo] valueForKey:@"index"] intValue];
	Question *question = (Question*)[currentItems objectAtIndex:index];
	responsesViewController.curQuestion = question;
	[responsesViewController makeHttpRequest];
	//[responsesViewController fetchResponses: question];	

	// Show the response view controller
	//[questionsViewController.view removeFromSuperview];
	[detailViewController.view addSubview:responsesViewController.view];	
	[responsesViewController viewDidAppear:NO];
	
	// Set current root view to questions
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.currentView = QuestionsView;
	[self changeDetailsTitle:@"Responses"];
	if ([[question subject] length] > 20 ) {
		[self changeDetailsRootButtonTitle: [NSString stringWithFormat:@"%@...", [[question subject] substringWithRange:NSMakeRange(0, 20)]]];
	} else {
		[self changeDetailsRootButtonTitle:[question subject]];
	}
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
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	if(appDelegate.currentView == CategoriesView && [currentItems count] > 0) {
		headerLabel.text = @"Categories";
	} else if( appDelegate.currentView == TopicsView) {
		headerLabel.text = @"Topics";
	}
	else if( appDelegate.currentView == QuestionsView) {
		headerLabel.text = @"Questions";
	}
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
	//[self.tableView deleteRowsAtInd exPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	if(appDelegate.currentView == CategoriesView) {			
		Category *category = (Category*)[currentItems objectAtIndex:indexPath.row];
		appDelegate.currentSlug = category.slug;
		[topicsViewController makeHttpRequest];
		[self changeDetailsRootButtonTitle:[category name]];
	} else if (appDelegate.currentView == TopicsView) {
		[questionsViewController.items removeAllObjects];
		[questionsViewController setCurrentPage:1];
		Topic *topic = (Topic*)[currentItems objectAtIndex:indexPath.row];
		//[questionsViewController fetchQuestions: topic];
		questionsViewController.curTopic = topic;
		[questionsViewController makeHttpRequest];
		[self changeDetailsRootButtonTitle:[topic name]];
	} else if (appDelegate.currentView == QuestionsView) {
		//[responsesViewController fetchResponses: (Question*)[currentItems objectAtIndex:indexPath.row]];	
		responsesViewController.curQuestion = (Question*)[currentItems objectAtIndex:indexPath.row];	
		[responsesViewController makeHttpRequest];
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
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	[loginButton release];
	[logoutButton release];
	[currentItems release];	
	[categories release];
	[dimmer release];
	[topicsViewController release];
    [detailViewController release];
	[questionsViewController release];
	[responsesViewController release];
    [super dealloc];
}


@end

