//
//  RootViewController.m
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
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

@implementation RootViewController

@synthesize detailViewController;
@synthesize categoriesViewController;
@synthesize topicsViewController;
@synthesize questionsViewController, responsesViewController, profileViewController;
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
	
	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.currentOrientation = [[UIDevice currentDevice] orientation];
	
	[appDelegate.progressHUD hideUsingAnimation:YES];
	
	
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	switch (orientation) {
        case UIInterfaceOrientationPortrait:		
        case UIInterfaceOrientationPortraitUpsideDown:
			appDelegate.appWidth = 768.f;
			appDelegate.appHeight = 1004.f;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			appDelegate.appWidth = 703.f;
			appDelegate.appHeight = 748.f;
			break;
		default:
			NSLog(@"Orientation not detected");
			break;
    }
	
	//UIView *backgroundView = [[UIView alloc] initWithFrame: self.view.frame];
	//backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-tile.png"]];
	//[self.view addSubview:backgroundView];
	//[backgroundView release];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-tile.png"]];
	
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
	//UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comment_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(postButtonPressed:)];
	UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"key_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonPressed:)];
	UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"man_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonPressed:)];
	
	[detailViewController.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, flexibleSpace, flexibleSpace, backButton, refreshButton, loginButton, profileButton, nil]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToCategories:) name:@"ChangeToCategories" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToTopics:) name:@"ChangeToTopics" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToQuestions:) name:@"ChangeToQuestions" object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dialogClose:) name:@"DialogClose" object:nil]; 	
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];          	
	self.navigationItem.leftBarButtonItem = homeButton;

	UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aelogica.png"]] autorelease];	
	self.navigationItem.title = @"";
	//self.navigationItem.titleView = logo;	
	
	currentView = CategoriesView;
	
	//self.navigationController.navigationBar.topItem.title = @"Categories";	

	
	// Set to categories view on launch app
	[detailViewController.view addSubview:categoriesViewController.view];
	

	
}

-(void)homeButtonPressed:(UIBarButtonItem *)button {
	[self changeToHome];
}

-(void)loginButtonPressed:(UIBarButtonItem *)button {
	// Dim the background
	[self.view.window addSubview:dimmer];
	
	LoginDialog *dialog = [[LoginDialog alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 250.f)];
	[dialog setupView:nil];
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



-(void)postButtonPressed:(UIBarButtonItem *)button {
	if(currentView != TopicsView && currentView != QuestionsView) {
		return;
	}

	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];	
	BaseDialog *dialog = nil;
	
	if(currentView == TopicsView){
		dialog = [[QuestionDialog alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 400.f)];
		[dialog setupView:(Topic*)[currentItems objectAtIndex:indexPath.row]];
	} else if (currentView == QuestionsView) {
		dialog = [[ResponseDialog alloc] initWithFrame:CGRectMake(0.f, 0.f, 600.f, 250.f)];
		[dialog setupView:(Question*)[currentItems objectAtIndex:indexPath.row]];
	}
	
	[dialog doAppearAnimation: self.view.window];	
	[self.view.window addSubview:dialog];


	[dialog release];
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
	if(currentView == CategoriesView) {
		[self changeToHome];
	} else if (currentView == TopicsView) {
		[self changeToCategories:nil];
	} else if (currentView == QuestionsView) {
		[self changeToTopics:nil];
	}
}

-(void)refreshButtonPressed:(UIBarButtonItem *)button {
	if(currentView == CategoriesView) {	
		//[self changeToTopics:nil];
	} else if( currentView == TopicsView) {
		[questionsViewController setCurrentPage:1];
		[questionsViewController.questions removeAllObjects];                                           
		[questionsViewController fetchQuestions: questionsViewController.currentTopic];		
	}
	else if( currentView == QuestionsView) {
		[responsesViewController fetchResponses:questionsViewController.currentQuestion];	
	}
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
	[titleButton release];
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
	
	[self changeDetailsTitle:@""];

	[detailViewController.view addSubview:categoriesViewController.view];
}

-(void)changeToCategories:(NSNotification *)pUserInfo { 
	[categoriesViewController.view removeFromSuperview];
	[responsesViewController.view removeFromSuperview];
	[questionsViewController.view removeFromSuperview];
	
	//UITableView *newTableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    //self.tableView = newTableView;	
	
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:categoriesViewController.categories];
	[self.tableView reloadData];

	currentView = CategoriesView;	
	[self changeDetailsTitle:@"Topics"];

	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue]	;
	[topicsViewController fetchTopics: [(Category*)[categoriesViewController.categories objectAtIndex:pass] slug]];		
	[detailViewController.view addSubview:topicsViewController.view];	
}

-(void)changeToTopics:(NSNotification *)pUserInfo { 
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:topicsViewController.topics];
	[self.tableView reloadData];
	
	currentView = TopicsView;
	[self changeDetailsTitle:@"Questions"];

	[topicsViewController.view removeFromSuperview];
	[responsesViewController.view removeFromSuperview];
	
	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue];
	[questionsViewController switchTableViewStyle:UITableViewStyleGrouped];	
	[questionsViewController setCurrentPage:1];
	[questionsViewController.questions removeAllObjects];
	[questionsViewController fetchQuestions: (Topic*)[currentItems objectAtIndex:pass]];
	
	[detailViewController.view addSubview:questionsViewController.view];	
	[questionsViewController viewDidAppear:NO];

} 


-(void)changeToQuestions:(NSNotification *)pUserInfo { 
	// Remove all items and replace it with those from the questions
	[currentItems removeAllObjects];
	[currentItems addObjectsFromArray:questionsViewController.questions];
	[self.tableView reloadData];	
	
	[questionsViewController switchTableViewStyle:UITableViewStylePlain];
	[self.view addSubview:questionsViewController.view];	
	[questionsViewController viewDidAppear:NO];

	//oldTableView = self.tableView;
	//self.tableView = questionsViewController.tableView;	
	
	// Set current root view to questions
	currentView = QuestionsView;
	[self changeDetailsTitle:@"Responses"];
	
	int pass = [[[pUserInfo userInfo] valueForKey:@"pass"] intValue]	;
	[responsesViewController fetchResponses: (Question*)[questionsViewController.questions objectAtIndex:pass]];	

	// Show the response view controller
	//[questionsViewController.view removeFromSuperview];
	[detailViewController.view addSubview:responsesViewController.view];	
	[responsesViewController viewDidAppear:NO];
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
	
	if(currentView == CategoriesView && [currentItems count] > 0) {
		headerLabel.text = @"Categories";
	} else if( currentView == TopicsView) {
		headerLabel.text = @"Topics";
	}
	else if( currentView == QuestionsView) {
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

	if(currentView == CategoriesView) {			
		[topicsViewController fetchTopics: [(Category*)[currentItems objectAtIndex:indexPath.row] slug]];		
	} else if (currentView == TopicsView) {
		[questionsViewController.questions removeAllObjects];
		[questionsViewController setCurrentPage:1];
		[questionsViewController fetchQuestions: (Topic*)[currentItems objectAtIndex:indexPath.row]];
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


@end

