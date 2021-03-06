//
//  RUGradeViewController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 20/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUGradeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RUGradeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UITextView *feedbackView;


@end

@implementation RUGradeViewController

@synthesize grade = _grade;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self courseLabel] setText:[[self grade] getCourse]];
    [[self gradeLabel] setText:[[self grade] getGrade]];
    [[self rankLabel] setText:[[self grade] getRank]];
    
    if(![[[self grade] feedback] isEqualToString:@" "])
    {
        [[self feedbackView] setText:[[self grade] feedback]];
    }
    else
    {
        [[self feedbackView] setText:@"No feedback"];
    }
    
    //[[self.feedbackView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    //[[self.feedbackView layer] setBorderWidth:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setGrade:(RUGrade *)grade
{
    _grade = grade;
    [self setTitle:[grade assignmentName]];
}

@end
