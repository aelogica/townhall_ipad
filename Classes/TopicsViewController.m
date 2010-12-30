    //
//  TopicsViewController.m
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TopicsViewController.h"
#import "Topic.h"
#import "GTMHTTPFetcher.h"
#import "GenericTownHallAppDelegate.h"

@implementation TopicsViewController

@synthesize tableView, topics;

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
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.view setFrame:CGRectMake(.0f, 44.f, 768.f, 1004.f)];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(.0f, 100.f, 768.f, 1004.f) style:UITableViewStyleGrouped];
	//self.tableView.separatorColor = [UIColor clearColor];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundView:nil];
	[self.view addSubview:tableView];
	
	self.topics = [[NSMutableArray alloc] init];
	
	// Listen to orientaton changes
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
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
	return [topics count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	Topic *topic = (Topic *)[topics objectAtIndex:indexPath.row];
	
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
		[firstLabel setFrame:CGRectMake(250.f, 0.f, 300.f, 100.f)];
		[firstLabel setBackgroundColor:[UIColor clearColor]];
		[firstLabel setTextColor:[UIColor redColor]];
		firstLabel.font = [UIFont systemFontOfSize:22];	
		firstLabel.text = topic.name;
		[[cell contentView] addSubview:firstLabel];
		[firstLabel release];
		
		UILabel *secondLabel = [[UILabel alloc] init];
		[secondLabel setFrame:CGRectMake(400.f, 0.f, 100.f, 100.f)];
		[secondLabel setBackgroundColor:[UIColor clearColor]];
		[secondLabel setTextColor:[UIColor greenColor]];
		secondLabel.font = [UIFont systemFontOfSize:15];	
		secondLabel.text = @"View Questions";
		//[[cell contentView] addSubview:secondLabel];
		[secondLabel release];
		
		UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder.png"];
		UIImageView *placeHolderImageView = [[UIImageView alloc] initWithImage:placeHolderImage];
		placeHolderImageView.alpha = 0.8f;
		[placeHolderImageView setFrame:CGRectMake(40.f, 10, 180.0, 76.0)];
		[cell.contentView addSubview:placeHolderImageView];
		
		UIImage *accessoryImage = [UIImage imageNamed:@"icon.png"];
		UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
		//accImageView.userInteractionEnabled = YES;
		[accImageView setFrame:CGRectMake(0, 0, 133.0, 102.0)];
		cell.accessoryView = accImageView;
		[accImageView release];
    }
	
	UILabel *name = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
	[name setFrame:CGRectMake(250.f, 0.f, 300.f, 100.f)];
	name.text = topic.name;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"pass"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToTopics" object:nil userInfo:userInfo];
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
	[topics dealloc];
    [super dealloc];
}

-(void)fetchTopics :(NSString *) slug {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/topics/in/%@?format=json", UIAppDelegate.serverDataUrl, slug]];
	NSLog(@"Fetching topics URL: %@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:error:)];	

	
	GenericTownHallAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.progressHUD showUsingAnimation:YES];
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
		NSLog(@"Fetch topics failed");
	} else {
		[topics removeAllObjects];
		
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
		
		// Create an array out of the returned json string
	    NSArray *results = [jsonString JSONValue];

		NSLog(@"Fetch topics succeeded. Count: %d", [results count]);
		
		for (NSDictionary *objectInstance in results) {
			
			Topic *topic = [Topic alloc];
			topic.name = [objectInstance objectForKey:@"Name"];
			topic.slug = [objectInstance objectForKey:@"Slug"];
			
			[topics addObject: topic];
			
		}
		[self.tableView reloadData];
		/*
		[tableView layoutIfNeeded];
		
		CGRect f = tableView.frame;
		f.size.height = [tableView contentSize].height;
		tableView.frame = f;		
		
		UITextView *textView = (UITextView*)[self.view viewWithTag: 1];
		f = textView.frame;
		f.origin.y = tableView.frame.size.height + tableView.frame.origin.y + 1.f;
		textView.frame = f;

		UIButton *button = (UIButton*)[self.view viewWithTag: 2];
		f = button.frame;		
		f.origin.y = textView.frame.size.height + textView.frame.origin.y + 1.f;
		button.frame = f;
		*/
		
	}
}

@end
