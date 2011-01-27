//
//  ResponsesViewController.h
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

@interface ResponsesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *responses;
	
	Question *currentQuestion;
	UIView *headerView;
	UIToolbar *toolbar;

}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property(nonatomic, retain) UIView *headerView;
@property(nonatomic, retain) UIToolbar *toolbar;
@property(nonatomic, retain) NSMutableArray *responses;
@property(nonatomic, retain) Question *currentQuestion;

-(void)fetchResponses:(Question *) question;

@end
