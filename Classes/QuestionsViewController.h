//
//  QuestionsViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Question;
@class Topic;

@interface QuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView* tableView;
	NSMutableArray *questions;
	NSInteger currentPage;
	NSString *currentSortColumn;
	Question *currentQuestion;
	Topic *currrentTopic;
	
	UIView *headerView;
	UIToolbar *toolbar;
	UIBarButtonItem *postButton;
	UILabel *topicName;
}

@property (nonatomic, retain) UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *questions;
@property(nonatomic, retain) UIView *headerView;
@property(nonatomic, retain) UIToolbar *toolbar;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) Topic *currentTopic;
@property(nonatomic, assign) Question *currentQuestion;

-(void)fetchQuestions:(Topic *) aTopic;

@end
