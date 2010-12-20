//
//  QuestionsViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *questions;
	NSInteger currentPage;
	NSString *currentSlug;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *questions;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSString *currentSlug;

-(void)fetchQuestions:(NSString *) slug;

@end
