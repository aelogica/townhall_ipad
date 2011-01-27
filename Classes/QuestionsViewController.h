//
//  QuestionsViewController.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
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
