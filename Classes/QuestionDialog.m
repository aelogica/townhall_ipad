//
//  InputDialog.m
//  GenericTownHall
//
//  Created by David Ang on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuestionDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "GenericTownHallAppDelegate.h"
#import "GTMHTTPFetcher.h"
#import "Category.h"

@implementation QuestionDialog

@synthesize category;

- (id)initWithFrameAndQuestion:(CGRect)frame category: (Category*)aCategory {
	if ((self = [super initWithFrame:frame])) {
        // Initialization code
		category = aCategory;
		
		[self setBackgroundColor:UIColorFromRGB(0x87CEFA)];
		//[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		float padding = 10.f;
		float navbarHeight = 44.f;
		
		UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 44.f)];		
		
		UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Add your question"];
		//navItem.hidesBackButton = YES;
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonSystemItemDone target:self action:@selector(sendButtonPressed:)] autorelease];
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemDone target:self action:@selector(cancelButtonPressed:)] autorelease];
		[navBar pushNavigationItem:navItem animated:NO];
		
		[navItem release];
		
		[self addSubview:navBar];
		CGSize size = [category.description sizeWithFont:[UIFont systemFontOfSize:14.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
		CGRect nameFrame = CGRectMake(padding, navbarHeight + padding, self.frame.size.width - (padding * 2.f), 20.f);
		CGRect bodyFrame = CGRectMake(padding, navbarHeight + nameFrame.size.height + padding, self.frame.size.width - (padding * 2.f), size.height);
		
		UILabel *name = [[UILabel alloc] initWithFrame:nameFrame];
		name.text = [NSString stringWithFormat:@"Adding question to: %@", category.name];
		name.font = [UIFont systemFontOfSize:14.f];		
		[self addSubview:name];
		[name release];
		
		UILabel *body = [[UILabel alloc] initWithFrame:bodyFrame];
		body.numberOfLines = 0;
		body.lineBreakMode = UILineBreakModeWordWrap;
		body.text = category.description;
		body.font = [UIFont systemFontOfSize:14.f];
		[self addSubview:body];
		[body release];
		
		// Create textview and put right after the table view
		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, bodyFrame.origin.y + bodyFrame.size.height + padding, self.frame.size.width - (padding * 2.f), 100.f)];
		textView.backgroundColor = UIColorFromRGB(0x87CEFA);
		textView.tag = 1;
		[textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
		[textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
		[textView.layer setBorderWidth: 1.f];
		[textView.layer setCornerRadius:8.f];
		[textView.layer setMasksToBounds:YES];
		
		[self addSubview:textView];
		[textView release];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(padding, textView.frame.size.height + textView.frame.origin.y + padding, self.frame.size.width - (padding * 2.f), 30.f)];
		[textField setBorderStyle: UITextBorderStyleRoundedRect];
		[textField setPlaceholder:@"Enter tags for this question"];
		[self addSubview:textField];
		[textField release];
    }
    return self;
}

- (void)sendButtonPressed: (id)sender {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/questions/in/%@/create", UIAppDelegate.serverDataUrl, category.slug]];	
	NSLog(@"Posting a question to Url: %@", url);
	
	UITextView *textView = (UITextView*)[self.subviews objectAtIndex:3];
	UITextField *textField = (UITextField*)[self.subviews objectAtIndex:4];	
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSString *post = [NSString stringWithFormat:@"body=%@&tags=%@&categorySlug=%@", [textView text], [textField text], category.slug];  
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
