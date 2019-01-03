//
//  YTKViewController.m
//  YTKWebView
//
//  Created by lihc on 12/24/2018.
//  Copyright (c) 2018 lihc. All rights reserved.
//

#import "YTKViewController.h"
#import <YTKWebView/YTKWebView.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface YTKViewController () <UIWebViewDelegate, YTKWebViewLifecycleDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) YTKWebViewLifecycle *lifecycle;

@end

@implementation YTKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    self.lifecycle = [[YTKWebViewLifecycle alloc] initWithWebView:self.webView];
    self.lifecycle.delegate = self;

    NSURL *URL = [NSURL URLWithString:@"https://www.quanjing.com/imgbuy/QJ6919057308.html"];
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.frame;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

#pragma mark - YTKWebViewLifecycleDelegate

- (void)webViewLifecycle:(YTKWebViewLifecycle *)lifecycle webView:(UIWebView *)webView lifecycleStateDidChange:(YTKWebViewLifecycleState)state {
    NSLog(@"lifecycle state did change: %@", @(state));
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

#pragma mark - Getter

- (UIWebView *)webView {
    if (nil == _webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

@end
