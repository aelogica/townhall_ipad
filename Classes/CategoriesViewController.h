//
//  CategoriesViewController.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
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
