//
//  RUAssignmentCell.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 13/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUAssignmentCell.h"

@interface RUAssignmentCell()

@property (weak, nonatomic) IBOutlet UIImageView *doneImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end


@implementation RUAssignmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAssignment:(RUAssignment*)assignment
{
    [[self nameLabel] setText:[assignment title]];
    [[self courseLabel] setText:[assignment courseName]];
    [[self dateLabel] setText:[assignment dueDate]];
    
    if(![[assignment handedIn] isEqualToString:@"Óskilað"])
    {
        [[self doneImage] setHidden:NO];
    }
    else
    {
        [[self doneImage] setHidden:YES];
    }
}

// Prevent checkmark from being displayed when it shouldnt (bug fix)
-(void)prepareForReuse
{
    [[self doneImage] setHidden:YES];
}

@end
