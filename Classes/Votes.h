//
//  Topic.h
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CurrentUserVote.h";


@interface Votes : NSObject {
	NSString * _upVotes;
	NSString * _downVotes;
	NSString  *  _upPercentage;
	NSString * _downPercentage;
	//CurrentUserVote * _currentUserVote;
	
}
//NOTE - we use NSINTEGER for percentages as the UI doesn't need to be that precise
@property(nonatomic, copy) NSString * upVotes;
@property(nonatomic, copy) NSString * downVotes;
@property(nonatomic, copy) NSString  * upPercentage;
@property(nonatomic, copy) NSString * downPercentage;

//@property(nonatomic, assign) CurrentUserVote * currentUserVote;


@end