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


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
			
		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, frame.size.width, 44.f)];
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
		
		[toolbar release];
		
		
		
    }
    return self;
}

- (id)initWebViewWithUrl : (NSString*)urlTo {

	
}

- (void) doneButtonPressed : (id)sender {
	[self removeFromSuperview];
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
