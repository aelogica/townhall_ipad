//
//  TopicsViewController.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>


@interface TopicsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *topics;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *topics;

-(void)fetchTopics:(NSString *) slug;

@end
