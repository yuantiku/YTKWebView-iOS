//
//  YTKWebView.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/27.
//

#import <UIKit/UIKit.h>
#import "YTKWebViewLifecycle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YTKJsCommandHandler;

@interface YTKWebView : UIView

@property (nonatomic, readonly) YTKWebViewLifecycleState state;

/** 是否手动控制webView的生命周期，默认NO */
@property (nonatomic) BOOL manualControlLifecycle;

@property (nonatomic, weak, nullable) id<YTKWebViewLifecycleDelegate> lifecycleDelegate;

- (instancetype)initWithWebView:(UIWebView *)webView;

/** JS交互相关接口 */
/** 调用js commandName方法 */
- (NSString *)callJsCommandName:(NSString *)commandName
                       argument:(nullable NSArray *)argument
                   errorMessage:(nullable NSString *)errorMessage;

/** 注入js方法commandName, 方法实现类handler */
- (void)addJsCommandHandler:(id<YTKJsCommandHandler>)handler forCommandName:(NSString *)commandName;

/** 移除已经注入的js方法commandName */
- (void)removeJsCommandHandlerForCommandName:(NSString *)commandName;

@end

NS_ASSUME_NONNULL_END
