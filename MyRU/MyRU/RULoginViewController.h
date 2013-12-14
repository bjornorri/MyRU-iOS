//
//  RULoginViewController.h
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 11/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RULoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UILabel *invalidLabel;

- (IBAction)submit:(id)sender;

@end
