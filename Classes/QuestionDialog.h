//
//  InputDialog.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
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
