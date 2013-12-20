//
//  RUGradeCell.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 12/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUGradeCell.h"

@interface RUGradeCell ()

@property (weak, nonatomic) IBOutlet UILabel *assignmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic, setter = setGrade:) RUGrade* grade;

@end

@implementation RUGradeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGrade:(RUGrade*)grade;
{
    [[self assignmentLabel] setText:[grade assignmentName]];
    [[self rankLabel] setText:[grade order]];
    [[self gradeLabel] setText:[grade getGrade]];
}


@end
