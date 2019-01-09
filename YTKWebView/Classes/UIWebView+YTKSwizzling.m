//
//  UIWebView+YTKSwizzling.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import "UIWebView+YTKSwizzling.h"
#import <objc/runtime.h>
#import "NSObject+YTKObject.h"

NSString * const YTKDidCallWebViewSetDelegateNotification = @"YTKDidCallWebViewSetDelegateNotification";
NSString * const YTKDidCallSetDelegateLifecycleKey = @"YTKDidCallSetDelegateLifecycleKey";
NSString * const YTKDidCallSetDelegateDelegateKey = @"YTKDidCallSetDelegateDelegateKey";

@implementation UIWebView (YTKSwizzling)

+ (void)load {
    // hook UIWebView
    Method originalMethod = class_getInstanceMethod([UIWebView class], @selector(setDelegate:));
    Method swizzledMethod = class_getInstanceMethod([UIWebView class], @selector(ytk_setDelegate:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)ytk_setDelegate:(id<UIWebViewDelegate>)delegate {
    // 获得 delegate 的实际调用类
    Class class = NSClassFromString(@"YTKWebViewLifecycle");
    if ([self.ytk_retainObject isKindOfClass:class] && NO == [delegate isKindOfClass:class]) {
        [self ytk_setDelegate:self.ytk_retainObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:YTKDidCallWebViewSetDelegateNotification object:self userInfo:@{YTKDidCallSetDelegateLifecycleKey : self.ytk_retainObject, YTKDidCallSetDelegateDelegateKey : delegate}];
    } else {
        [self ytk_setDelegate:delegate];
    }
}

@end
