//
//  ResponsesViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;

@interface ResponsesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *responses;
	
	Question *currentQuestion;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *responses;
@property(nonatomic, retain) Question *currentQuestion;

-(void)fetchResponses:(Question *) question;

@end
