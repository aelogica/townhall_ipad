//
//  Category.m
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Originator.h"


@implementation Originator

@synthesize userId = _userId;
@synthesize displayName= _displayName;
@synthesize displayNameSlug = _displayNameSlug;
@synthesize emailHash = _emailHash;
@synthesize userReputationPoints = _userReputationPoints;
@synthesize userReputationString = _userReputationString;
@synthesize avatar = _avatar;

- (id)copyWithZone:(NSZone *)zone
{
	Originator *copy = [[[self class] allocWithZone:zone] init];
	copy.displayName = self.displayName;
	copy.displayNameSlug = self.displayNameSlug;
	copy.emailHash = self.emailHash;
	copy.userReputationPoints = self.userReputationPoints;
	copy.userReputationString = self.userReputationString;
	copy.avatar = self.avatar;
	return copy;
}


-(void)dealloc{
	/*self.userId = nil;
	self.displayName = nil;
	self.displayNameSlug = nil;
	self.emailHash = nil;
	self.userReputationPoints = nil;
	self.userReputationString = _userReputationString;
	self.avatar = nil;
	*/
	[super dealloc];
}
@end
