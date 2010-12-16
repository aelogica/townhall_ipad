//
//  Response.h
//  TownHallServiceClient
//
//  Created by Marc Mercuri on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Originator.h";


@interface Response : NSObject {
	NSInteger * _responseId;
	NSString * _body;
//	Originator * _originator;
}

@property(nonatomic, assign) NSInteger * responseId;
@property(nonatomic, copy) NSString * body;
//@property(nonatomic, copy) Originator * originator;

@end
