//
//  Originator.h
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Originator : NSObject {
	NSInteger * _userId;
	NSString * _displayName;
	NSString * _displayNameSlug;
	NSString * _emailHash;
	NSInteger * _userReputationPoints;
	NSString * _userReputationString;
	NSString * _avatar;
}

@property(nonatomic, assign) NSInteger * userId;
@property(nonatomic, copy) NSString * displayName;
@property(nonatomic, copy) NSString * displayNameSlug;
@property(nonatomic, copy) NSString * emailHash;
@property(nonatomic, assign) NSInteger * userReputationPoints;
@property(nonatomic, copy) NSString * userReputationString;
@property(nonatomic,copy) NSString * avatar;

@end
