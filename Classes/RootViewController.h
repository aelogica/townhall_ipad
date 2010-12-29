//
//  RootViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class CategoriesViewController;
@class TopicsViewController;
@class QuestionsViewController;
@class ResponsesViewController;
@class ProfileViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	CategoriesViewController *categoriesViewController;
	TopicsViewController *topicsViewController;	
	QuestionsViewController *questionsViewController;
	ResponsesViewController *responsesViewController;
	ProfileViewController *profileViewController;
	
	UIView *dimmer;
	UITableView *oldTableView;

	NSMutableArray *categories;
	NSMutableArray *currentItems;
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

-(void)changeDetailsTitle:(NSString*)newTitle;
-(void)changeToCategories:(NSNotification *)pUserInfo;


@end
