//
//  TwitterView.h
//  GenericTownHall
//
//  Created by David Ang on 3/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterView : UIView {
	UIWebView *webView;
	UIToolbar *toolbar;
}

- (id) initWithFrame:(CGRect)frame url:(NSString*)urlTo;

@end
