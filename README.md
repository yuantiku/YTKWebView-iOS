# YTKWebView

[![CI Status](https://img.shields.io/travis/lihc/YTKWebView.svg?style=flat)](https://travis-ci.org/yuantiku/YTKWebView-iOS)
[![Version](https://img.shields.io/cocoapods/v/YTKWebView.svg?style=flat)](https://cocoapods.org/pods/YTKWebView)
[![License](https://img.shields.io/cocoapods/l/YTKWebView.svg?style=flat)](https://cocoapods.org/pods/YTKWebView)
[![Platform](https://img.shields.io/cocoapods/p/YTKWebView.svg?style=flat)](https://cocoapods.org/pods/YTKWebView)

## YTKWebView 是什么

YTKWebView是对UIWebView更高层级的封装一个工具类，给UIWebView封装了生命周期以及Get请求拦截的能力，生命周期概念包括：loading加载中、ready加载完毕、close关闭，主要依赖UIWebViewDelegate、NSURLProtocol来实现的。
 
## YTKWebView 提供了哪些功能

 * 支持生命周期概念。
 * 支持自动或者手动管理生命周期。
 * 支持生命周期变化通知，包括Protocol、Notification的通知方式。
 * 支持拦截WebView内部发出的所有Get请求。

## 哪些项目适合使用 YTKWebView

YTKWebView 适合ObjectC实现的项目，并且项目中使用UIWebView作为网页展示的容器。

如果你的项目使用了YTKWebView，将会提升WebView的加载速度以及用户使用体验。

## YTKWebView 的基本思想

YTKWebView 的节本思想是给UIWebView封装上一个生命周期的概念以及提供拦截Get请求的能力，可以配合客户端的缓存来使用，进而提升网页的加载渲染速度与效果。

生命周期状态发生变化会通过代理或notification的方式通知使用方，使用方可以根据状态变化做一些事情，例如：loading状态的时候显示native loading 的UI，这样webView没有渲染完毕之前，用户不会看到一个空白页面之类的；close状态的时候清理webView资源等。

由于网页需要显示的资源都是通过Get请求来完成加载的，因此如果大部分的资源加载Get请求都会命中本地缓存直接返回，将会极大的提升WebView的加载速度，如果没有命中缓存就实际发送网络请求，因此在YTKWebView工具类中拦截了所有的Get请求，但是是否真的拦截Get请求，交由使用方来决定，例如：可以让UIWebView与native共享相同的图片缓存，类似使用SDWebImage来实现图片的加载，首先会询问是否命中缓存，如果使用方通过SDWebImage查询命中缓存，则将图片本地缓存文件地址返回给YTKWebView，那么YTKWebView将会拦截该请求，将缓存文件数据返回给该请求，这样相同的图片就不会在WebView与native之间多次加载。

## 安装

你可以在Podfile中加入下面一行代码来使用YTKWebView

```ruby
pod 'YTKWebView'
```
## 安装要求

| YTKWebView 版本 |  最低 iOS Target | 注意 |
|:----------------:|:----------------:|:-----|
| 0.1.0 | iOS 7 | 要求 Xcode 7 以上 |

## 例子

clone当前repo， 到Example目录下执行`pod install`命令，就可以运行例子工程

## 使用方法

首先，看是否需要主动管理YTKWebView的生命周期，如果不需要管理，则只需要监听生命周期变化通知即可；如果需要主动管理YTKWebView生命周期，则需要通过业务代码来管理YTKWebView的生命周期，一个典型的例子就是JS控制YTKWebView的生命周期，然后通知native来做一些事情，例如显示loading UI等，如下所示：

```objective-c
// 主动管理生命周期

// 监听YTKWebView生命周期变化通知
```

其次，根据需求看是否需要拦截YTKWebView展示内容所需要发出的Get网络请求，如果不需要拦截，则无需额外代码；如果需要拦截请求，则需要实现具体缓存命中的逻辑，如下所示：

```objective-c
// 拦截webView所发出的网络请求
```

## 作者

YTKWebView 的主要作者是：

lihc， https://github.com/xiaochun0618

## 协议

YTKWebView 被许可在 MIT 协议下使用。查阅 LICENSE 文件来获得更多信息。
