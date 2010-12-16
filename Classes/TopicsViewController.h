//
//  TopicsViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopicsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *topics;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *topics;

-(void)fetchTopics:(NSString *) slug;

@end
