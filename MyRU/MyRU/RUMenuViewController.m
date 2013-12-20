//
//  RUMenuViewController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 20/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUMenuViewController.h"

@interface RUMenuViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation RUMenuViewController

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
	// Do any additional setup after loading the view.
    
    [self refresh:nil];
}
- (IBAction)refresh:(id)sender
{
    [self.webView setAlpha:0.0];
    NSURL* fullUrl = [NSURL URLWithString:@"http://malid.ru.is"];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:fullUrl];
    [self.webView loadRequest:urlRequest];
}


#pragma mark - webView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Hide all unnecessary elements on the page.
    NSString* js = @"var page=document.getElementsByClassName('item entry')[0];var bd=document.getElementById('bd');bd.innerHTML=page.innerHTML;var bla=document.getElementById('doc3');bla.setAttribute('id', '');bla.setAttribute('class', '');document.getElementById('ft').style.display='none'";
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
