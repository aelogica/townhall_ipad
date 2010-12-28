//
//  CategoriesViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;

@interface CategoriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *categories;
	UITableView *tableView;
}

@property (nonatomic, retain) UITableView* tableView;
@property(nonatomic, retain) NSMutableArray *categories;

@end
