//
//  YTKWebRequestAgent.m
//  Pods-YTKWebView_Example
//
//  Created by lihaichun on 2018/12/29.
//

#import "YTKWebRequestAgent.h"

@implementation YTKWebRequestAgent

+ (instancetype)sharedAgent {
    static id sharedAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAgent = [[self alloc] init];
    });
    return sharedAgent;
}

@end

