//
//  Nugget.h
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Originator.h";
#import "Votes.h";
//#import "CurrentUserVote.h";


@interface Question: NSObject {
	NSString * _nuggetId;
	NSString * _subject;
	NSString * _subjectSlug;
	NSString * _category;
	NSString * _categoryName;

	NSString * _body;
	Originator * _nuggetOriginator;
	Votes * _votes;
	NSInteger * _topNuggetVoteCount;
    NSString * _nuggetFlags;
    NSString * _dateCreated;
	NSDate * _dateModified;
	NSMutableArray * _userSpecificTags;
	NSString *_responseCount;
	NSMutableArray * _responses;
	
}

@property(nonatomic, copy) NSString * nuggetId;
@property(nonatomic, copy) NSString * subject;
@property(nonatomic, copy) NSString * subjectSlug;
@property(nonatomic, copy) NSString * category;
@property(nonatomic, copy) NSString * categoryName;
@property(nonatomic, copy) NSString * body;
@property(nonatomic, assign) Originator * nuggetOriginator;
@property(nonatomic, assign) Votes * votes;
@property(nonatomic, assign) NSInteger * topNuggetVoteCount;
@property(nonatomic, assign) NSString * nuggetFlags;
@property(nonatomic,copy) NSString * dateCreated;
@property(nonatomic,copy) NSDate * dateModified;
@property(nonatomic, assign)  NSMutableArray * userSpecificTags;
@property(nonatomic, assign)  NSMutableArray * responses;
@property(nonatomic, assign)  NSString *responseCount;

-(NSString*)dateCreatedFormatted;
-(NSString*)dateStringFromString:(NSString *)sourceString
					  sourceFormat:(NSString *)sourceFormat
				 destinationFormat:(NSString *)destinationFormat;



@end
