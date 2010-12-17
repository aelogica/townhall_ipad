//
//  LoginDialog.m
//  GenericTownHall
//
//  Created by David Ang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginDialog.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"

@implementation LoginDialog


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundColor:UIColorFromRGB(0x87CEFA)];
		//[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		float padding = 10.f;
		
		UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 44.f)];		
		
		UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Enter login credentials"];
		//navItem.hidesBackButton = YES;
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonSystemItemDone target:self action:@selector(loginButtonPressed:)] autorelease];
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemDone target:self action:@selector(cancelButtonPressed:)] autorelease];
		[navBar pushNavigationItem:navItem animated:NO];
		
		[navItem release];
		
		[self addSubview:navBar];

		UITextField *loginField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 44.f + padding, self.frame.size.width - (padding * 2.f), 30.f)];
		[loginField setBorderStyle: UITextBorderStyleRoundedRect];
		[loginField setPlaceholder:@"Enter your username"];
		[self addSubview:loginField];		
		
		UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(padding, loginField.frame.size.height + loginField.frame.origin.y + padding, self.frame.size.width - (padding * 2.f), 30.f)];
		[passwordField setBorderStyle: UITextBorderStyleRoundedRect];
		[passwordField setPlaceholder:@"Enter your password"];
		[self addSubview:passwordField];		
    }
    return self;
}

- (void)loginButtonPressed: (id)sender {
	UITextField *loginField = (UITextField*)[self.subviews objectAtIndex:1];	
	UITextField *passwordField = (UITextField*)[self.subviews objectAtIndex:2];	
	NSLog(@"Authenticating user: %@", [loginField text]);

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/account/authenticate?format=xml", UIAppDelegate.serverBaseUrl]];	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", [loginField text], [passwordField text]];  
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: postData];
	
	GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
	[myFetcher beginFetchWithDelegate:self didFinishSelector:@selector(postRequestHandler:finishedWithData:error:)];		
}

- (void)cancelButtonPressed: (id)sender {	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector: @selector(cancelAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration:.7f];	
	[self setAlpha:0.f];
	[UIView commitAnimations];
}

- (void)cancelAnimationDidStop:(NSString*) animationID finished:(NSNumber*) finished context:(void*) context {
	[self removeFromSuperview];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DialogClose" object:nil userInfo:nil];
}

- (void)postRequestHandler:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector: @selector(cancelAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration:.7f];	
	[self setAlpha:0.f];
	[UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
