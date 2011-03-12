//
//  ResponsesViewController.h
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "BaseViewController.h"

@class Question;

@interface ResponsesViewController : BaseViewController {
	Question *curQuestion;
}

@property(nonatomic, retain) Question *curQuestion;

-(void)fetchResponses:(Question *) question;

@end
