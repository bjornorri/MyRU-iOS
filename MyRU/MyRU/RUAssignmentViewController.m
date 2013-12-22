//
//  RUAssignmentViewController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 15/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUAssignmentViewController.h"
#import "RUData.h"

@interface RUAssignmentViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RUAssignmentViewController
@synthesize assignment = _assignment;


- (void)setAssignment:(RUAssignment *)assignment
{
    _assignment = assignment;
    [[self navigationItem] setTitle:[assignment title]];
}

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
    
    NSMutableString* urlString = [NSMutableString stringWithString:@"https://myschool.ru.is/myschool/"];
    
    [urlString appendString:[[self assignment] assignmentURL]];
    
    NSURL* fullURL = [NSURL URLWithString:urlString];
    
    NSString* basicAuthentication = [[RUData sharedData] getAuthentication];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:fullURL];
    
    [urlRequest setValue:basicAuthentication forHTTPHeaderField:@"Authorization"];
    
    [self.webView setAlpha:0.0];
    [[self webView] loadRequest:urlRequest];
}

- (IBAction)refresh:(id)sender
{
    [self.webView setAlpha:0.0];
    NSMutableString* urlString = [NSMutableString stringWithString:@"https://myschool.ru.is/myschool/"];
    [urlString appendString:[[self assignment] assignmentURL]];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
}


#pragma mark - webView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Hide unnecessary elements and enlarge everything else.
    NSString* js = [NSMutableString stringWithString:@"$('.ruHeader a').click(function(e){e.preventDefault()});$('.ruLeft').hide();$('.ruRight').hide();$('.ruFooter').hide();$('#headersearch').hide();$('.level1').hide();$('.resetSize').click();$('.increaseSize').click();$('.increaseSize').click();$('.increaseSize').click()"];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    [self.webView setAlpha:1.0];
    [self.activityIndicator stopAnimating];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The page could not be loaded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

@end

