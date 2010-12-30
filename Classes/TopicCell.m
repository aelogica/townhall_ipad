//
//  TopicCell.m
//  GenericTownHall
//
//  Created by David Ang on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "TopicCell.h"
#import "Topic.h"

@implementation TopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backView.backgroundColor = [UIColor blackColor];
		backView.alpha = 0.3f;	
		backView.opaque = NO;
		//backView.layer.cornerRadius = 10.f;
		//cell.backgroundView = backView;
		self.backgroundColor = [UIColor blackColor];		
		self.alpha = 0.5f;
		self.selectedBackgroundView = backView;
		
		// Set cell to transparent background
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
		//self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		name = [[UILabel alloc] init];
		[name setFrame:CGRectMake(250.f, 0.f, 300.f, 100.f)];
		[name setBackgroundColor:[UIColor clearColor]];
		[name setTextColor:[UIColor redColor]];
		name.font = [UIFont systemFontOfSize:22];	
		[[self contentView] addSubview:name];
		[name release];
		
		UILabel *secondLabel = [[UILabel alloc] init];
		[secondLabel setFrame:CGRectMake(400.f, 0.f, 100.f, 100.f)];
		[secondLabel setBackgroundColor:[UIColor clearColor]];
		[secondLabel setTextColor:[UIColor greenColor]];
		secondLabel.font = [UIFont systemFontOfSize:15];	
		secondLabel.text = @"View Questions";
		//[[self contentView] addSubview:secondLabel];
		[secondLabel release];
		
		UIImage *placeHolderImage = [UIImage imageNamed:@"placeholder.png"];
		UIImageView *placeHolderImageView = [[UIImageView alloc] initWithImage:placeHolderImage];
		placeHolderImageView.alpha = 0.8f;
		[placeHolderImageView setFrame:CGRectMake(40.f, 10, 180.0, 76.0)];
		[self.contentView addSubview:placeHolderImageView];
		
		UIImage *accessoryImage = [UIImage imageNamed:@"icon.png"];
		UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
		//accImageView.userInteractionEnabled = YES;
		[accImageView setFrame:CGRectMake(0, 0, 133.0, 102.0)];
		self.accessoryView = accImageView;
		[accImageView release];
		
    }
    return self;
}

-(void)updateCellWithModel:(id*)aModel {
	Topic *topic = (Topic*)aModel;
	
	//[name setFrame:CGRectMake(250.f, 0.f, 300.f, 100.f)];
	//[name setTextColor:[UIColor redColor]];
	name.text = topic.name;
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
