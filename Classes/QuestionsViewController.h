//
//  QuestionsViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;

@interface QuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *questions;
	NSInteger currentPage;
	NSString *currentSlug;
	Question *currentQuestion;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *questions;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSString *currentSlug;
@property(nonatomic, assign) Question *currentQuestion;

-(void)fetchQuestions:(NSString *) slug;

@end
