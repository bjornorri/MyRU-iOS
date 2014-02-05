//
//  RUClassCell.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 03/02/14.
//  Copyright (c) 2014 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUClassCell.h"
#import "RUTabBarController.h"
#import "RUData.h"

@interface RUClassCell ()

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (strong, nonatomic) CALayer* maskLayer;
@property (strong, nonatomic) CALayer* lineLayer;

@end

@implementation RUClassCell

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


- (void)setClass:(RUClass *)class
{
    if(self.maskLayer && self.lineLayer)
    {
        [self.maskLayer removeFromSuperlayer];
        [self.lineLayer removeFromSuperlayer];
        self.maskLayer = nil;
        self.lineLayer = nil;
    }
    
    [[self courseLabel] setText:[class course]];
    [[self locationLabel] setText:[class location]];
    [[self startLabel] setText:[class startString]];
    [[self endLabel] setText:[class endString]];
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
        
        if([class isNow])
        {
            // Calculate how far down the cell the mask and line layers should be
            float classDuration = [[class endDate] timeIntervalSinceDate:[class startDate]];
            float classTime = [[NSDate date] timeIntervalSinceDate:[class startDate]];
            float ratio = classTime/classDuration;
            int layerHeight = floor(ratio * self.bounds.size.height);
            
            // Create mask layer
            self.maskLayer = [CALayer layer];
            self.maskLayer.anchorPoint = self.bounds.origin;
            self.maskLayer.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, layerHeight + 1);
            self.maskLayer.backgroundColor = CGColorCreateCopyWithAlpha([UIColor whiteColor].CGColor, 0.7);
            
            
            // Create line layer
            self.lineLayer = [CALayer layer];
            self.lineLayer.anchorPoint = CGPointMake(self.bounds.origin.x, self.bounds.origin.y - layerHeight - 1);
            self.lineLayer.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + layerHeight, self.bounds.size.width, 1);
            self.lineLayer.backgroundColor = [UIColor redColor].CGColor;
            
            // Add mask and line layers
            [[self layer] addSublayer:self.maskLayer];
            [[self layer] addSublayer:self.lineLayer];
            
            
            // Add animation
            
            float duration = classDuration - classTime;
            
            CABasicAnimation* lineAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            lineAnimation.fromValue = [self.lineLayer valueForKey:@"position"];
            lineAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.origin.x, self.bounds.size.height - layerHeight - 2)];
            lineAnimation.duration = duration;
            lineAnimation.delegate = self;
            
            CABasicAnimation* maskAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
            maskAnimation.fromValue = [self.maskLayer valueForKey:@"bounds.size"];
            maskAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height - 2)];
            maskAnimation.duration = duration;
            maskAnimation.delegate = self;
            
            [self.lineLayer addAnimation:lineAnimation forKey:@"position"];
            [self.maskLayer addAnimation:maskAnimation forKey:@"bounds.size"];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag)
    {
        if(self.maskLayer && self.lineLayer)
        {
            [self.maskLayer removeFromSuperlayer];
            [self.lineLayer removeFromSuperlayer];
            [[self contentView ] setAlpha:0.3];
            self.maskLayer = nil;
            self.lineLayer = nil;
        }
    }
}

@end
