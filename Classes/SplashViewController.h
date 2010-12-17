//
//  SplashViewController.h
//  GenericTownHall
//
//  Created by David Ang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
