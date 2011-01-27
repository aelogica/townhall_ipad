    //
//  CategoriesViewController.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "CategoriesViewController.h"
#import "GTMHTTPFetcher.h"
#import "Category.h"
#import "GenericTownHallAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@implementation CategoriesViewController

@synthesize categories, tableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	self.view = [[UIView alloc] initWithFrame: CGRectMake(.0f, 44.f, appDelegate.appWidth, appDelegate.appHeight)];
	[self.view setBackgroundColor:[UIColor clearColor]];	
	
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 100.f, appDelegate.appWidth, appDelegate.appHeight) style:UITableViewStyleGrouped];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundView:nil];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	//[tableView setAlpha:0.5f];
	//tableView.backgroundColor = [UIColor blackColor];
	//tableView.opaque = NO;	
	
	[self.view addSubview:tableView];
	
	categories = [[NSMutableArray alloc] init];
	
	/*
	UINavigationBar *navBar = 	[self.navigationController navigationBar];
	//UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.f, 48.0f)];
	
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Microsoft Town Hall Topics"];
	navItem.hidesBackButton = YES;
	[navBar pushNavigationItem:navItem animated:NO];
	[navItem release];
	
	[self.view addSubview: navBar];	
	 */
	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
	
	UIImage *stepsImage = [UIImage imageNamed:@"steps.png"];
	UIImageView *stepsImageView = [[UIImageView alloc] initWithImage:stepsImage];
	[stepsImageView setFrame:CGRectMake(0, 834.f, 768.0, 128.0)];
	[self.view addSubview:stepsImageView];

	
	[self fetchCategories];
	
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
	return [categories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backView.backgroundColor = [UIColor blackColor];
		backView.alpha = 0.3f;	
		backView.opaque = NO;
		//backView.layer.cornerRadius = 10.f;
		//cell.backgroundView = backView;
		cell.backgroundColor = [UIColor blackColor];		
		cell.alpha = 0.5f;
		cell.selectedBackgroundView = backView;
		
		// Set cell to transparent background
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		UILabel *firstLabel = [[UILabel alloc] init];
		[firstLabel setFrame:CGRectMake(250.f, 0.f, 200.f, 100.f)];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		[firstLabel setTextColor:[UIColor redColor]];
		firstLabel.font = [UIFont systemFontOfSize:22];	
		firstLabel.text =[(Category *)[categories objectAtIndex:indexPath.row] name];
		[[cell contentView] addSubview:firstLabel];
		[firstLabel release];
		
		UILabel *secondLabel = [[UILabel alloc] init];
		[secondLabel setBackgroundColor:[UIColor clearColor]];
		[secondLabel setTextColor:[UIColor greenColor]];
		secondLabel.font = [UIFont systemFontOfSize:15];	
		secondLabel.text = @"View Topics";
		secondLabel.tag = 1;
		[[cell contentView] addSubview:secondLabel];
		[secondLabel release];

		UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder.png"];
		UIImageView *placeHolderImageView = [[UIImageView alloc] initWithImage:placeHolderImage];
		placeHolderImageView.alpha = 0.8f;
		[placeHolderImageView setFrame:CGRectMake(40.f, 10, 180.0, 76.0)];
		[cell.contentView addSubview:placeHolderImageView];
		
		UIImage *accessoryImage = [UIImage imageNamed:@"icon2.png"];
		UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
		//accImageView.userInteractionEnabled = YES;
		[accImageView setFrame:CGRectMake(0, 0, 133.0, 102.0)];
		cell.accessoryView = accImageView;
		[accImageView release];
    }
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	UILabel *secondLabel = (UILabel*)[cell.contentView viewWithTag:1];
    if(appDelegate.currentOrientation == UIInterfaceOrientationPortrait || appDelegate.currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		secondLabel.frame = CGRectMake(480.f, 0.f, 100.f, 100.f);
	} else {
		secondLabel.frame = CGRectMake(515.f, 35.f, 100.f, 100.f);
	}
	
    // Set up the cell...
     //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	 //cell.textLabel.text = [(Category *)[categories objectAtIndex:indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToCategories" object:nil userInfo:userInfo];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"CategoriesViewController dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];	  
    [super dealloc];
}


-(void)fetchCategories{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/categories/all?format=json", UIAppDelegate.serverDataUrl]];
	NSLog(@"Fetching top categories URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(myFetcher:finishedWithData:error:)];	
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD showUsingAnimation:YES];
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
		//NSArray *allCategories = [results objectForKey:@"CatListModel"];
		NSLog(@"Fetch responses succeeded. Count: %d", [results count]);
		
		//for (NSDictionary *objectInstance in allCategories) {
		for (NSDictionary *objectInstance in results) {	
			Category *cat = [Category alloc];
			cat.name = [objectInstance objectForKey:@"Name"];
			cat.slug = [objectInstance objectForKey:@"Slug"];
			cat.description = [objectInstance objectForKey:@"Description"];
			
			[categories addObject: cat];
		}
		[self.tableView reloadData];
	}
}


@end
