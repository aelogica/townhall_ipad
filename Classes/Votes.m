//
//  Topic.m
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Votes.h"
//#import "CurrentUserVote.h";

@implementation Votes

@synthesize upVotes = _upVotes;
@synthesize downVotes= _downVotes;
@synthesize  upPercentage = _upPercentage;
@synthesize  downPercentage = _downPercentage;
//@synthesize  currentUserVote = _currentUserVote;

-(id)init
{
    if (self = [super init])
    {
		
		//_currentUserVote = [[CurrentUserVote alloc]init];
				
    }
    return self;
}
-(void)dealloc{
	//self.upVotes = nil;
	//self.downVotes = nil;
	//self.upPercentage = nil;
	//self.downPercentage = nil;
	//self.currentUserVote = nil;
	
	[super dealloc];
}
@end
