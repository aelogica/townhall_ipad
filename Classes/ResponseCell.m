//
//  ResponseCell.m
//  GenericTownHall
//
//  Created by David Ang on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResponseCell.h"
#import "GenericTownHallAppDelegate.h"
#import "AsynchImageView.h"
#import "Response.h"

@implementation ResponseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		UIView *backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backgroundView.backgroundColor = UIColorFromRGB(0x77a236);		
		self.backgroundView = backgroundView;		
		
		UIView *authorBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];		
		authorBackgroundView.backgroundColor = UIColorFromRGB(0x54811c);			
		
		UILabel *primaryLabel = [[UILabel alloc]init];
		primaryLabel.textAlignment = UITextAlignmentLeft;
		primaryLabel.font = [UIFont systemFontOfSize:16];
		
		primaryLabel.numberOfLines = 0;
		primaryLabel.lineBreakMode = UILineBreakModeWordWrap;
		primaryLabel.backgroundColor = [UIColor clearColor];
		
		UILabel *secondaryLabel = [[UILabel alloc]init];
		secondaryLabel.textAlignment = UITextAlignmentLeft;
		secondaryLabel.font = [UIFont systemFontOfSize:14];
		secondaryLabel.backgroundColor = [UIColor clearColor];	
		
		[self.contentView addSubview:authorBackgroundView];
		[self.contentView addSubview:primaryLabel];
		[self.contentView addSubview:secondaryLabel];
		
    }
    return self;
}

-(void)updateCellWithModel:(id*)aModel {
	Response *response = (Response*)aModel;

	UILabel *authorBackgroundView = (UILabel*)[self.contentView.subviews objectAtIndex:0];
	UILabel *body = (UILabel*)[self.contentView.subviews objectAtIndex:1];
	UILabel *author = (UILabel*)[self.contentView.subviews objectAtIndex:2];
	CGSize size = [response.body sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(500.f, MAXFLOAT)];
	
	
	CGRect frame = CGRectMake(10.f, 0, 600.f, 80.f);
	body.frame = frame;	
	
	CGFloat authorOriginY = frame.size.height + frame.origin.y;
	frame = CGRectMake(0.f, authorOriginY, 768.f, 25.f);
	authorBackgroundView.frame = frame;
	frame = CGRectMake(10.f, authorOriginY, 768.f, 25.f);
	author.frame = frame;	
	
	body.text = response.body;
	author.text = [NSString stringWithFormat:@"Posted by %@ (%@ pts).", response.originator.displayName, response.originator.userReputationString];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
