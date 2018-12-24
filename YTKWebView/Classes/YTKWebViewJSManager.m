//
//  YTKWebViewJSManager.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/21.
//  Copyright © 2018年 fenbi. All rights reserved.
//

#import "YTKWebViewJSManager.h"
#import "UIWebView+JavaScriptContext.h"
#import "YTKJSCommandHandler.h"
#import "YTKJSCommand.h"

@interface YTKWebViewJSManager () <YTKWebViewDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "Wdeprecated-declarations"
@property (nonatomic, strong) UIWebView *webView;
#pragma clang diagnostic pop

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<YTKJSCommandHandler>> *pendingJSHandlers;

@end

@implementation YTKWebViewJSManager

+ (NSString *)callJSCommandName:(NSString *)commandName
                       argument:(NSArray *)argument
                   errorMessage:(NSString *)errorMessage
                      inWebView:(UIWebView *)webView {
    if (webView == nil || commandName == nil) {
        return nil;
    }

    NSMutableArray *args = [NSMutableArray array];
    // put error message
    if (errorMessage != nil) {
        [args addObject:errorMessage];
    } else {
        [args addObject:[NSNull null]];
    }
    // put result
    if (argument.count > 0) {
        [args addObjectsFromArray:argument];
    }

    NSString *js = [NSString stringWithFormat:@"%@('%@')", commandName, [self jsonString:args]];
    return [webView stringByEvaluatingJavaScriptFromString:js];
}

+ (NSString *)jsonString:(NSArray *)array {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    if (error) {
        NSLog(@"ERROR, faild to get json data");
        return nil;
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

- (instancetype)initWithWebView:(UIWebView *)webView {
    self = [super init];
    if (self) {
        _webView = webView;
        _pendingJSHandlers = @{}.mutableCopy;
        webView.ytk_delegate = self;
    }
    return self;
}

- (void)addJSCommandHandler:(id<YTKJSCommandHandler>)handler forCommandName:(NSString *)commandName {
    if (nil == handler || NO == [commandName isKindOfClass:[NSString class]]) {
        NSLog(@"ERROR, invalid parameter");
        return;
    }
    if (self.webView.ytk_javaScriptContext) {
        [self addJSCommandHandler:handler forCommandName:commandName toContext:self.webView.ytk_javaScriptContext];
    } else {
        [self.pendingJSHandlers setObject:handler forKey:commandName];
    }
}

- (void)addJSCommandHandler:(id<YTKJSCommandHandler>)handler forCommandName:(NSString *)commandName toContext:(JSContext *)context {
    if (nil == handler || NO == [commandName isKindOfClass:[NSString class]] || nil == context) {
        return;
    }
    context[commandName] = ^(JSValue *data) {
        handler.webView = self.webView;
        if ([handler respondsToSelector:@selector(handleJSCommand:inWebView:)]) {
            YTKJSCommand *commamd = [[YTKJSCommand alloc] initWithDictionary:[data toObjectOfClass:[YTKJSCommand class]]];
            [handler handleJSCommand:commamd inWebView:self.webView];
        }
    };
}

#pragma mark - YTKWebViewDelegate

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)context {
    [self.pendingJSHandlers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<YTKJSCommandHandler>  _Nonnull obj, BOOL * _Nonnull stop) {
        [self addJSCommandHandler:obj forCommandName:key toContext:context];
    }];
}

@end
