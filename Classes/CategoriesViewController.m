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

#import "Category.h"

@implementation CategoriesViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	/*
	UINavigationBar *navBar = 	[self.navigationController navigationBar];
	//UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.f, 48.0f)];
	
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Microsoft Town Hall Topics"];
	navItem.hidesBackButton = YES;
	[navBar pushNavigationItem:navItem animated:NO];
	[navItem release];
	
	[self.view addSubview: navBar];	
	 */
}

#pragma mark Table view methods

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
		firstLabel.text =[(Category *)[items objectAtIndex:indexPath.row] name];
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

- (NSString*)getServiceUrl {
	return @"categories/all";
}

- (void)handleHttpResponse:(NSString*)responseString {

	// Create an array out of the returned json string
	NSDictionary *results = [responseString JSONValue];
	//NSArray *allCategories = [results objectForKey:@"CatListModel"];
	NSLog(@"Fetch responses succeeded. Count: %d", [results count]);
	
	//for (NSDictionary *objectInstance in allCategories) {
	for (NSDictionary *objectInstance in results) {	
		Category *cat = [Category alloc];
		cat.name = [objectInstance objectForKey:@"Name"];
		cat.slug = [objectInstance objectForKey:@"Slug"];
		cat.description = [objectInstance objectForKey:@"Description"];
		
		[items addObject: cat];
	}
}

- (void)dealloc {
	NSLog(@"CategoriesViewController dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];	  
    [super dealloc];
}

@end
