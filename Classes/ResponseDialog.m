//
//  ResponseDialog.m
//  GenericTownHall
//
//  Created by David Ang on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResponseDialog.h"
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"

@implementation ResponseDialog


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundColor:UIColorFromRGB(0x87CEFA)];
		//[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		float padding = 10.f;
		
		UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 44.f)];		
		
		UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Add your response"];
		//navItem.hidesBackButton = YES;
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonSystemItemDone target:self action:@selector(sendButtonPressed:)] autorelease];
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemDone target:self action:@selector(cancelButtonPressed:)] autorelease];
		[navBar pushNavigationItem:navItem animated:NO];
		
		[navItem release];
		
		[self addSubview:navBar];
		
		// Create textview and put right after the table view
		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, 44.f + padding, self.frame.size.width - (padding * 2.f), 100.f)];
		textView.backgroundColor = UIColorFromRGB(0x87CEFA);
		textView.tag = 1;
		[textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
		[textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
		[textView.layer setBorderWidth: 1.f];
		[textView.layer setCornerRadius:8.f];
		[textView.layer setMasksToBounds:YES];
		
		[self addSubview:textView];
		[textView release];		
		
    }
    return self;
}

- (void)sendButtonPressed: (id)sender {
	NSString *slug = @"917";
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/responses/for/%@/create", UIAppDelegate.serverDataUrl, slug]];	
	NSLog(@"Posting a response to Url: %@", url);
	
	UITextView *textView = (UITextView*)[self.subviews objectAtIndex:1];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = [NSString stringWithFormat:@"body=%@", [textView text]];  
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
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
