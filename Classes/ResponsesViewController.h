//
//  ResponsesViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponsesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *responses;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *responses;

-(void)fetchResponses:(NSString *) slug;

@end
