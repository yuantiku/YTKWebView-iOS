# YTKWebView

[![CI Status](https://img.shields.io/travis/lihc/YTKWebView.svg?style=flat)](https://travis-ci.org/yuantiku/YTKWebView-iOS)
[![Version](https://img.shields.io/cocoapods/v/YTKWebView.svg?style=flat)](https://cocoapods.org/pods/YTKWebView)
[![License](https://img.shields.io/cocoapods/l/YTKWebView.svg?style=flat)](https://cocoapods.org/pods/YTKWebView)
[![Platform](https://img.shields.io/cocoapods/p/YTKWebView.svg?style=flat)](https://cocoapods.org/pods/YTKWebView)

## YTKWebView 是什么

YTKWebView是对UIWebView更高层级的封装一个工具类，给UIWebView封装了生命周期、JS注入通信以及Get请求拦截的能力，生命周期概念包括：init初始化、loading加载中、succeed加载完毕、failed加载失败、close关闭，主要依赖UIWebViewDelegate、NSURLProtocol、runtime、YTKJSBridge、YTKResourceCache来实现的。
 
## YTKWebView 提供了哪些功能

 * 支持生命周期概念。
 * 支持自动或者手动管理生命周期。
 * 支持生命周期变化通知，包括Protocol、Notification的通知方式。
 * 支持拦截WebView内部发出的所有Get请求，并支持设置特殊的UIWebView UserAgent拦截。
 * 支持向webView注入JS方法。
 * 支持调用webView提供的js方法。

## 哪些项目适合使用 YTKWebView

YTKWebView 适合ObjectC实现的项目，并且项目中使用UIWebView作为网页展示的容器，并且有较多的JS通信、请求拦截的需求。

如果你的项目使用了YTKWebView，将会提升WebView的加载速度以及用户使用体验，节省JS通信的开发成本提高开发效率。

## YTKWebView 的基本思想

YTKWebView 的基本思想是给UIWebView封装上一个生命周期的概念以及提供拦截Get请求的能力，可以配合客户端的缓存来使用，进而提升网页的加载渲染速度与效果。

对于webView的UIWebViewDelegate的回调不会产生影响，生命周期状态发生变化会通过protocol或notification的方式通知使用方，使用方可以根据状态变化做一些事情，例如：loading状态的时候显示native loading 的UI，这样webView没有渲染完毕之前，用户不会看到一个空白页面之类的；close状态的时候清理webView资源等。

由于网页需要显示的资源都是通过Get请求来完成加载的，因此如果大部分的资源加载Get请求都会命中本地缓存直接返回，将会极大的提升WebView的加载速度，如果没有命中缓存就实际发送网络请求，因此在YTKWebView工具类中拦截了所有UIWebView发送的Get请求，但是是否真的拦截Get请求，交由使用方来决定，例如：可以让UIWebView与native共享相同的图片缓存，类似使用SDWebImage来实现图片的加载，首先会询问是否需要拦截请求，如果使用方判断是图片请求，则需要拦截，那么YTKWebView将会拦截该请求，并在请求开始的时候向使用方索要图片数据，使用方将缓存图片数据返回给YTKWebViewURLProtocol，这样相同的图片就不会在WebView与native之间多次加载。

通过JSContext注入的方式实现JS同步调用native的方法，从而实现JS与native之间互相同步调用。

## 安装

你可以在Podfile中加入下面一行代码来使用YTKWebView

```ruby
pod 'YTKWebView'
```
## 安装要求

| YTKWebView 版本 |  最低 iOS Target | 注意 |
|:----------------:|:----------------:|:-----:|
| 0.1.0 | iOS 7 | 要求 Xcode 7 以上 |

## 例子

clone当前repo， 到Example目录下执行`pod install`命令，就可以运行例子工程

## 使用方法

生命周期使用方法，看是否需要主动管理YTKWebView的生命周期，如果不需要管理，则只需要监听生命周期变化通知即可；如果需要主动管理YTKWebView生命周期，则需要通过业务代码来管理YTKWebView的生命周期，一个典型的例子就是JS控制YTKWebView的生命周期，例如显示loading UI等，然后通知native来做一些事情，如下所示：

```objective-c
// 手动管理生命周期
UIWebView *webView = [UIWebView new];
YTKWebView *ytkWebView = [[YTKWebView alloc] initWithWebView:webView];
ytkWebView.lifecycleDelegate = self;

// 监听YTKWebView生命周期变化通知，支持protocol以及notification的方式，这里以protocol为例
#pragma mark - YTKWebViewLifecycleDelegate
- (void)webViewLifecycle:(YTKWebViewLifecycle *)lifecycle webView:(UIWebView *)webView lifecycleStateDidChange:(YTKWebViewLifecycleState)state {
    NSLog(@"lifecycle did change: %@", @(state));
}
```

JS互调使用方法，看是否需要使用JS注入方法以及调用JS方法的能力，下面以向JS注入sayHello方法为例，如下所示：

```objective-c
UIWebView *webView = [UIWebView new];
YTKWebView *ytkWebView = [[YTKWebView alloc] initWithWebView:webView];
[ytkWebView addJsCommandHandler:[YTKAlertHandler new] forCommandName:@"sayHello"];
```

JS调用native注入的方法，下面就是JS调用native来执行sayHello方法的代码，由于客户端注入的sayHello方法不需要参数，因此传递数据data中的arguments是空的，如下所示：

```JavaScript
// 准备要传给客户端的数据，包括指令，数据，回调等
var data = {
    name:'sayHello',
    arguments:null,
    callback:'',
};
// 直接使用native注入的全局YTKJsBridge方法调用sayHello方法执行
YTKJsBridge(data);
```
native调用JS方法，下面就是native调用JS执行名为alert的JS方法，带有三个参数message，cancelTitle，confirmTitle，分别代表alert提示的文案、取消按钮文案、确认按钮文案，如下所示：

```objective-c
UIWebView *webView = [UIWebView new];
// webView加载代码省略...
YTKWebView *ytkWebView = [[YTKWebView alloc] initWithWebView:webView];
// 准备传入JS的数据，包括指令，数据等
NSDictionary *parameter = @{@"message" : @"hello, world",
                        @"cancelTitle" : @"cancel",
                       @"confirmTitle" : @"confirm"};
// 客户端调用网页的alert方法，弹出alert弹窗
[ytkWebView callJsCommandName:@"alert"
                     argument:@[parameter]
                 errorMessage:nil];
```

## 作者

YTKWebView 的主要作者是：

lihc， https://github.com/xiaochun0618

## 协议

YTKWebView 被许可在 MIT 协议下使用。查阅 LICENSE 文件来获得更多信息。
