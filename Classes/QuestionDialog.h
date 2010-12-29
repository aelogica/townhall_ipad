//
//  InputDialog.h
//  GenericTownHall
//
//  Created by David Ang on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDialog.h"

@class Category;
@class Topic;

@interface QuestionDialog : BaseDialog {
	Category *category;
	Topic *topic;

}

@property(nonatomic, assign) Category *category;
@property(nonatomic, assign) Topic *topic;

- (id)initWithFrameAndTopic:(CGRect)frame topic: (Topic*)aTopic;
- (NSString *)urlEncodeValue:(NSString *)str;

@end
