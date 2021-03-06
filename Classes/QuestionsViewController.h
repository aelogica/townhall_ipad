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


#import "BaseViewController.h"

#import "Question.h"
#import "Topic.h"

@interface QuestionsViewController : BaseViewController {
	Topic *curTopic;	
	Question *currentQuestion;
	
	NSString *currentSortColumn;
	
	UIBarButtonItem *postButton;
	UILabel *topicName;
}

@property(nonatomic, retain) UILabel *topicName;
@property(nonatomic, assign) Question *currentQuestion;
@property(nonatomic, assign) Topic *curTopic;
//
//-(void)fetchQuestions:(Topic *) aTopic;

@end
