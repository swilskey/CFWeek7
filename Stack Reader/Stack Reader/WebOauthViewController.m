//
//  WebOauthViewController.m
//  Stack Reader
//
//  Created by Sam Wilskey on 9/15/15.
//  Copyright © 2015 Wilskey Labs. All rights reserved.
//

#import "WebOauthViewController.h"
#import <WebKit/WebKit.h>

@interface WebOauthViewController () <WKNavigationDelegate>

@end

@implementation WebOauthViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  WKWebView *webView = [[WKWebView alloc] init];
  webView.frame = self.view.frame;
  [self.view addSubview:webView];
  
  webView.navigationDelegate = self;
  
  NSString *baseURL = @"https://stackexchange.com/oauth/dialog";
  NSString *clientID = @"5565";
  NSString *redirectURI = @"https://stackexchange.com/oauth/login_success";
  NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",baseURL,clientID,redirectURI];
  NSString *google = @"https://google.com";
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:google]]];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
    NSString *fragmentString = navigationAction.request.URL.fragment;
    NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
    NSString *fullTokenParameter = components.firstObject;
    NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:true completion:nil];
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}

@end
