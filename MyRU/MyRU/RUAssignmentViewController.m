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
    
    [[self webView] loadRequest:urlRequest];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Hide unnecessary elements
    NSString* js = [NSMutableString stringWithString:@"$('.ruHeader a').click(function(e){e.preventDefault()});$('.ruLeft').hide();$('.ruRight').hide();$('.ruFooter').hide();$('#headersearch').hide();$('.level1').hide();$('.resetSize').click();$('.increaseSize').click();$('.increaseSize').click()"];
    [webView stringByEvaluatingJavaScriptFromString:js];
}


@end

