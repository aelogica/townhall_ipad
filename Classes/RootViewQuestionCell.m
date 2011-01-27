//
//  RootViewQuestionCell.m
//  GenericTownHall  (TownHall iPad)
//
//  Created by David Ang and Steven Talcott Smith, AELOGICA LLC
//  Copyright 2010 Microsoft
//
//  This software is released under the Microsoft Public License
//  Please see the LICENSE file for details
//


#import "RootViewQuestionCell.h"
#import "GenericTownHallAppDelegate.h"
#import "Question.h"


@implementation RootViewQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.backgroundView.backgroundColor = UIColorFromRGB(0xdedede);		
		//selectedBackgroundView.backgroundColor = UIColorFromRGB(0x93c843);
		[voteUpMeter setHidden:YES];
		[voteDownMeter setHidden:YES];
		[voteUpButton setHidden:YES];
		[voteDownButton setHidden:YES];
		[voteBox setHidden:YES];
		[authorBackgroundView setBackgroundColor:UIColorFromRGB(0xababab)];
		
		CGRect frame = CGRectMake(10.f, 0, 150.f, 60.f);
		subject.frame = frame;	
		
		CGFloat authorOriginY = frame.size.height + frame.origin.y;
		frame = CGRectMake(0.f, authorOriginY, 300.f, 25.f);
		authorBackgroundView.frame = frame;
		frame = CGRectMake(10.f, authorOriginY, 300.f, 25.f);
		author.frame = frame;	
		
    }
    return self;
}

-(void)updateCellWithQuestion:(Question*)aQuestion {
	CGSize size = [aQuestion.subject sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(768.f, 55.f)];
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;	
	
	CGRect frame = CGRectMake(10.f, 0, 310.f, 80.f);
	subject.frame = frame;	
	
	CGFloat authorOriginY = frame.size.height + frame.origin.y;
	
	frame = CGRectMake(0.f, authorOriginY, 320.f, 25.f);
	authorBackgroundView.frame = frame;
	frame = CGRectMake(10.f, authorOriginY, 320.f, 25.f);
	author.frame = frame;	
	
	subject.text = aQuestion.subject;
	author.text = [NSString stringWithFormat:@"Posted by %@ at %@", aQuestion.nuggetOriginator.displayName, aQuestion.dateCreatedFormatted];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
