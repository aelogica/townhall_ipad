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

#import "AsynchImageView.h"
#import "RootViewQuestionCell.h"
#import "DetailViewQuestionCell.h"
#import "LoginDialog.h"
#import "QuestionDialog.h"

@implementation QuestionsViewController

@synthesize currentPage;
@synthesize curTopic;
@synthesize currentQuestion;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)loadView {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	currentPage = 1;
	currentSortColumn = @"date";	
	
    [super loadView];
	[super addTableView:UITableViewStylePlain];	
	[super addHeader];
	
	// UI for the header view
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
	NSArray *toolBarItems = [NSArray arrayWithObjects: flexItem, button1, button2, button3, button4, flexItem, postButton, nil];
	
	//release buttons
	[button1 release];
	[button2 release];
	[button3 release];
	[button4 release];
	//[button5 release];
	[flexItem release];
	
	//add array of buttons to toolbar
	[toolbar setItems:toolBarItems animated:NO];
}

- (NSString*)getServiceUrl {
	//NSString *url = [NSString stringWithFormat:@"browse/questions/in/%@/page/%d/sortKey/%@", curTopic.slug, currentPage, currentSortColumn];
	NSString *url = [NSString stringWithFormat:@"browse/questions/in/%@/page/%d", curTopic.slug, currentPage];
	return url;
}

- (NSString*)getExtraParams {
	return [NSString stringWithFormat:@"sortKey=%@", currentSortColumn];
}


- (void)handleHttpResponse:(NSString*)responseString {
	topicName.text = curTopic.name;
	
	// Create an array out of the returned json string
	NSArray *results = [responseString JSONValue];

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
		
		[items addObject: question];			
	}
}	

// Adjust the frame sizes of the various UI controls
//- (void)viewDidAppear:(BOOL)animated {
//	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
//	
//	CGFloat rootViewWidth = self.view.superview.frame.size.width;	
//	
//	// See if this view controller is showing up on the root view pane
//	if(rootViewWidth < 400.f) {
//		[headerView setHidden:YES];
//		[toolbar setFrame: CGRectMake(0, 0.f, self.view.superview.frame.size.width, 50.f)];
//		[self.tableView setFrame:CGRectMake(0.f, 50.f, rootViewWidth, UIAppDelegate.appHeight - 93.f)];
//		
//		// remove post question button
//		NSMutableArray * toolBarItems = [NSMutableArray arrayWithArray:toolbar.items];
//		if([toolBarItems count] == 7) {
//			[toolBarItems removeObjectAtIndex:6];
//			[toolbar setItems:toolBarItems];
//		}
//	}
//	// Otherwise set correct frame size for the details pane
//	else {
//		[headerView setHidden:NO];
//		[toolbar setFrame: CGRectMake(0, 100.f, self.view.superview.frame.size.width, 50.f)];
//		if(UIAppDelegate.currentOrientation == UIInterfaceOrientationPortrait || UIAppDelegate.currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//			[self.tableView setFrame:CGRectMake(.0f, 150.f, UIAppDelegate.appWidth, UIAppDelegate.appHeight - 200.f)];
//		} else {
//			[self.tableView setFrame:CGRectMake(.0f, 150.f, UIAppDelegate.appWidth, UIAppDelegate.appHeight - 150.f)];
//		}
//		NSMutableArray * toolBarItems = [NSMutableArray arrayWithArray:toolbar.items];
//		if([toolBarItems count] == 6) {
//			[toolBarItems insertObject:postButton atIndex:6];
//			[toolbar setItems:toolBarItems];
//		}
//	}
//	
//	[tableView reloadData];
//}
//

-(void)sortButtonPressed:(UIBarButtonItem *)button {
	currentSortColumn = (NSString*)button.tag;
	[self setCurrentPage:1];
	[items removeAllObjects];  
	[self makeHttpRequest];
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
		[dialog setupView:curTopic];
		
		[dialog doAppearAnimation: self.view.window];	
		[self.view.window addSubview:dialog];
		
		
		[dialog release];
	}

}

#pragma mark Table view methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// show an extra row at the bottom for the pagination
	NSInteger count = [items count];
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
		Question *question = (Question *)[items objectAtIndex:indexPath.row];

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
	NSString *text = [(Question*)[items objectAtIndex:indexPath.row] subject];
	
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

		currentQuestion = [items objectAtIndex:indexPath.row];
		
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToQuestions" object:nil userInfo:userInfo];
	} else {
		currentPage++;

		[self makeHttpRequest];
	}
}

- (void)dealloc {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];	  
	[toolbar dealloc];
	[postButton dealloc];
	[topicName dealloc];
    [super dealloc];
}

@end
