    //
//  BaseViewController.m
//  GenericTownHall
//
//  Created by David Ang on 3/11/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

@synthesize tableView;
@synthesize items;

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
	NSLog(@"BaseViewController %@: %@", NSStringFromSelector(_cmd), self);
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	items = [[NSMutableArray alloc] init];
	
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
	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
	
	UIImage *stepsImage = [UIImage imageNamed:@"steps.png"];
	UIImageView *stepsImageView = [[UIImageView alloc] initWithImage:stepsImage];
	[stepsImageView setFrame:CGRectMake(0, 834.f, 768.0, 128.0)];
	[self.view addSubview:stepsImageView]; 	
	
	[self makeHttpRequest];
}

-(void)orientationChange:(NSNotification *)orientation { 
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	CGRect f = tableView.frame;
	f.size.width = appDelegate.appWidth;
	tableView.frame = f;		
	
	[tableView reloadData];
}

-(void)makeHttpRequest {
	NSString *serviceUrl = [self getServiceUrl];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?format=json&ApiKey=6ad50a5a9b42848f65b63cc375ee3e92", UIAppDelegate.serverDataUrl, serviceUrl]];
	NSLog(@"Making HTTP request: %@", url);	
	
	// Create a request
	// You don't normally need to retain a synchronous request, but we need to in this case because we'll need it later if we reload the table data
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];	
	[request setValidatesSecureCertificate:NO];
	[request startAsynchronous];
	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD showUsingAnimation:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD hideUsingAnimation:YES];
	
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	// Create an array out of the returned json string
	NSDictionary *results = [responseString JSONValue];
	NSLog(@"Http request succeeded. Count: %d", [results count]);
	
	[self handleHttpResponse:responseString];
	
	[tableView reloadData];	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
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

#pragma mark Polymorphic methods
- (NSString*) getServiceUrl {
	return nil;
}

- (void)handleHttpResponse:(NSString*)responseString {	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)aTableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 100.0f;
}

- (void)dealloc {
	NSLog(@"BaseViewController %@: %@", NSStringFromSelector(_cmd), self);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];		  
	[items dealloc];
	
    [super dealloc];
}


@end
