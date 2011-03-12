    //
//  TopicsViewController.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "TopicsViewController.h"
#import "Topic.h"
#import "TopicCell.h"

@implementation TopicsViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    [super viewDidLoad];	
}

#pragma mark Table view methods

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	Topic *topic = (Topic *)[items objectAtIndex:indexPath.row];
	
    if (cell == nil) {
        cell = [[[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	[cell updateCellWithModel:topic];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToTopics" object:nil userInfo:userInfo];
}

- (NSString*)getServiceUrl {
	NSString *slug = @"parent-category-1";
	return [NSString stringWithFormat:@"topics/in/%@", UIAppDelegate.currentSlug];
}

- (void)handleHttpResponse:(NSString*)responseString {
	
	// Create an array out of the returned json string
	NSDictionary *results = [responseString JSONValue];
	//for (NSDictionary *objectInstance in allCategories) {
	for (NSDictionary *objectInstance in results) {	
		Topic *topic = [Topic alloc];
		topic.name = [objectInstance objectForKey:@"Name"];
		topic.slug = [objectInstance objectForKey:@"Slug"];
		[items addObject: topic];
	}
}

- (void)dealloc {
	NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);

    [super dealloc];
}


@end
