//
//  TwitterView.m
//  GenericTownHall
//
//  Created by David Ang on 3/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "TwitterView.h"
#import "GenericTownHallAppDelegate.h"

@implementation TwitterView

- (id) initWithFrame:(CGRect)frame url:(NSString*)urlTo {
	self = [super initWithFrame:frame];
    if (self) {
		CGRect webFrame = CGRectMake(0, 0, frame.size.width, frame.size.height - 44.f); 
		webView = [[UIWebView alloc] initWithFrame:webFrame]; 
		[webView setBackgroundColor:[UIColor blackColor]];
		
		NSURL *nsUrl = [NSURL URLWithString:urlTo];
		NSLog(@"twitter url: %@", nsUrl);
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsUrl]; 
		[webView loadRequest:requestObj]; 
		[self addSubview:webView]; 
		
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height - 44.f, frame.size.width, 44.f)];
		[toolbar setBarStyle:UIBarStyleBlack];	
		
		UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																	style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
		
		//Use this to put space in between your toolbox buttons
		UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				  target:nil
																				  action:nil];
		
		//Add buttons to the array
		NSArray *tbarItems = [NSArray arrayWithObjects: flexItem, doneBtn, nil];
		[doneBtn release];
		[flexItem release];
		
		// Add array of buttons to toolbar
		[toolbar setItems:tbarItems animated:NO];
		
		[self addSubview:toolbar];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:@"OrientationChange" object:nil]; 
    }
    return self;
}

- (void) doneButtonPressed : (id)sender {
	[self removeFromSuperview];
}

-(void)orientationChange:(NSNotification *)orientation { 
	CGRect viewFrame = self.frame;
	viewFrame.size.width = UIAppDelegate.appWidth;
	viewFrame.size.height = UIAppDelegate.appHeight;

	CGRect webFrame = webView.frame;
	webFrame.size.width = viewFrame.size.width;
	webFrame.size.height = viewFrame.size.height - 44;
	[webView setFrame: webFrame];
	
	CGRect toolbarFrame = toolbar.frame;
	toolbarFrame.origin.y = viewFrame.size.height - 44;
	toolbarFrame.size.width = viewFrame.size.width;
	[toolbar setFrame: toolbarFrame];
	
	[self setFrame:viewFrame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
	[toolbar release];
	[webView release];	
}


@end
