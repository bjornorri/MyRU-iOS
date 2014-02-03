//
//  RUClassCell.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 03/02/14.
//  Copyright (c) 2014 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUClassCell.h"

@interface RUClassCell ()

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@end

@implementation RUClassCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClass:(RUClass *)class
{
    [[self courseLabel] setText:[class course]];
    [[self locationLabel] setText:[class location]];
    [[self startLabel] setText:[class startTime]];
    [[self endLabel] setText:[class endTime]];
    [[self typeLabel] setText:[class type]];
    
    if([[class type] isEqualToString:@"Fyrirlestur"])
    {
        [[self typeImage] setImage:[UIImage imageNamed:@"lecture.png"]];
    }
    else if([[class type] isEqualToString:@"Dæmatími"])
    {
        [[self typeImage] setImage:[UIImage imageNamed:@"lab.png"]];
    }
    else if([[class type] isEqualToString:@"Viðtalstími"])
    {
        [[self typeImage] setImage:[UIImage imageNamed:@"help.png"]];
    }
    else
    {
        [[self typeImage] setImage:[UIImage imageNamed:@"rulogo.png"]];
    }
    
    if([class isOver])
    {
        [[self contentView] setAlpha:0.3];
    }
    else
    {
        [[self contentView] setAlpha:1.0];
    }
}

@end
