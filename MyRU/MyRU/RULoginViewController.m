//
//  RULoginViewController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 11/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RULoginViewController.h"
#import "RUData.h"

@interface RULoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;

@end

@implementation RULoginViewController

int BOTTOM_CONSTRAINT = 214;

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
    
    // This fixes a bug on 3,5 inch screens, where the login screen goes lower and lower each time you log out.
    BOTTOM_CONSTRAINT = 214;
    
    
    // Do any additional setup after loading the view from its nib.
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            BOTTOM_CONSTRAINT -= 88;
        }
        if(result.height == 568)
        {
            // iPhone 5
        }
        self.keyboardHeight.constant = BOTTOM_CONSTRAINT;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self addGradient:self.logInButton];
    [self observeKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender
{
    [self dismissKeyboard];
    
    [[self invalidLabel] setHidden:YES];
    [[self activityIndicator] setHidden:NO];
    [[self activityIndicator] startAnimating];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSString* username = [[self usernameField] text];
        NSString* password = [[self passwordField] text];
        
        NSString* basicAuthentication;
        NSString* string = [NSString stringWithFormat:@"%@:%@",username, password];
        NSString *base64EncodedString = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        basicAuthentication = [NSString stringWithFormat:@"Basic %@",base64EncodedString];
        
        [[RUData sharedData] setAuthentication:basicAuthentication];
        int statusCode = [[RUData sharedData] refreshData];
        
        dispatch_async( dispatch_get_main_queue(), ^
        {
            [[self activityIndicator] stopAnimating];
            if(statusCode == 200)
            {
                NSLog(@"Login successful!");
                [self performSegueWithIdentifier:@"unwindLoginSegue" sender:self];
            }
            else if(statusCode == 0)
            {
                [[RUData sharedData] setAuthentication:nil];
                [[self invalidLabel] setHidden:NO];
                NSLog(@"Invalid authentication!");
            }
            else
            {
                [[RUData sharedData] setAuthentication:nil];
                NSLog(@"Myschool is probably down...");
            }

        });
    });
    }

// This delegate method needs to be here. Always deny the unwind segue, trigger it manually instead.
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

// Some copy/paste function to add gradient to the login button.
// not sure i like this...
-(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 6.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}


#pragma mark - keyboard stuff


- (IBAction)textFieldDidEndEditing:(id)sender {
    
    if(sender == self.usernameField)
    {
        [self.passwordField becomeFirstResponder];
    }
    else
    {
        [sender resignFirstResponder];
    }
}



- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    //NSLog(@"Updating constraints.");
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.keyboardHeight.constant = height + 6;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardHeight.constant = BOTTOM_CONSTRAINT;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
