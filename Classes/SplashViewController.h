//
//  SplashViewController.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import <UIKit/UIKit.h>


@interface SplashViewController : UIViewController {
	NSTimer *timer;
	UIImageView *splashImageView;
	
	UISplitViewController *splitViewController;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIImageView *splashImageView;
@property (nonatomic, retain) UISplitViewController *splitViewController;


@end
