//
//  RootViewController.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class DetailViewController;
@class CategoriesViewController;
@class TopicsViewController;
@class QuestionsViewController;
@class ResponsesViewController;
@class ProfileViewController;

@interface RootViewController : UITableViewController <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate> {
    DetailViewController *detailViewController;
	CategoriesViewController *categoriesViewController;
	TopicsViewController *topicsViewController;	
	QuestionsViewController *questionsViewController;
	ResponsesViewController *responsesViewController;
	ProfileViewController *profileViewController;
	
	UIView *dimmer;
	UITableView *oldTableView;
	UIBarButtonItem *loginButton;
	UIBarButtonItem *logoutButton; 

	NSMutableArray *categories;
	NSMutableArray *currentItems;
    FBSession* fbSession;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet CategoriesViewController *categoriesViewController;
@property (nonatomic, retain) IBOutlet TopicsViewController *topicsViewController;
@property (nonatomic, retain) IBOutlet QuestionsViewController *questionsViewController;
@property (nonatomic, retain) IBOutlet ResponsesViewController *responsesViewController;
@property (nonatomic, retain) IBOutlet ProfileViewController *profileViewController;
@property (nonatomic, retain) NSMutableArray *currentItems;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) UIView *dimmer;
@property (nonatomic, retain) UITableView *oldTableView;
@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) UIBarButtonItem *logoutButton;

-(void)changeToHome;
-(void)changeToTopics:(NSNotification *)pUserInfo;
-(void)changeDetailsTitle:(NSString*)newTitle;
-(void)changeToCategories:(NSNotification *)pUserInfo;


@end
