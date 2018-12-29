//
//  YTKWebViewURLProtocol.m
//  Pods-YTKWebView_Example
//
//  Created by lihaichun on 2018/12/28.
//

#import "YTKWebViewURLProtocol.h"
#import "YTKWebRequestAgent.h"

static NSString * const kFilterLoopRequestKey = @"kFilterLoopRequestKey";
static NSString * const kDefaultWebViewUserAgentPattern = @"^Mozilla.*Mac OS X.*";
NSString * const YTKWebViewErrorNotImplemented = @"YTKWebViewErrorNotImplemented";

@implementation YTKWebViewURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *userAgent = request.allHTTPHeaderFields[@"User-Agent"];
    NSString *method = request.HTTPMethod;
    /** 如果不是webView发送的请求或者不是Get请求，不进行拦截 */
    id<YTKWebViewCacheFileLoader> loader = [YTKWebRequestAgent sharedAgent].cacheLoader;
    NSString *pattern = kDefaultWebViewUserAgentPattern;
    if ([loader respondsToSelector:@selector(webViewUserAgent)] && [loader webViewUserAgent]) {
        pattern = [loader webViewUserAgent];
    }

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    BOOL noneWebViewRequest = YES;
    if (userAgent) {
        NSTextCheckingResult *match = [regex firstMatchInString:userAgent options:0 range:NSMakeRange(0, userAgent.length)];
        noneWebViewRequest = match == nil;
    }
    BOOL isGetMethod = [method isEqualToString:@"GET"];
    if (noneWebViewRequest || NO == isGetMethod) {
        return NO;
    }

    if ([NSURLProtocol propertyForKey:kFilterLoopRequestKey inRequest:request]) {
        return NO;
    }

    /** 是否命中缓存，如果命中缓存，进行拦截；否则不进行拦截 */
    if ([loader respondsToSelector:@selector(loadFileByNativeWithRequest:)]) {
        BOOL load = [loader loadFileByNativeWithRequest:request];
        return load;
    } else {
        return NO;
    }
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}
- (void)startLoading {
    NSMutableURLRequest *mutableRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:kFilterLoopRequestKey inRequest:mutableRequest];

    id<YTKWebViewCacheFileLoader> loader = [YTKWebRequestAgent sharedAgent].cacheLoader;
    if ([loader respondsToSelector:@selector(loadFileWithRequest:completion:)]) {
        [loader loadFileWithRequest:self.request completion:^(NSData * _Nonnull data, NSError * _Nonnull error) {
            if (error) {
                [self.client URLProtocol:self didFailWithError:error];
                return;
            }
            NSString *mimeType = [self mimeTypeOfPathExtension:self.request.URL.pathExtension];
            NSMutableDictionary *headers = @{@"Content-Length" : @(data.length).stringValue}.mutableCopy;
            if (mimeType) {
                [headers setObject:mimeType forKey:@"Content-Type"];
            }
            NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headers];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
            [self.client URLProtocol:self didLoadData:data];
            [self.client URLProtocolDidFinishLoading:self];
        }];
    } else {
        [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:YTKWebViewErrorNotImplemented code:0 userInfo:@{}]];
    }
}

- (void)stopLoading {
    id<YTKWebViewCacheFileLoader> loader = [YTKWebRequestAgent sharedAgent].cacheLoader;
    if ([loader respondsToSelector:@selector(stopLoadingWithRequest:)]) {
        [loader stopLoadingWithRequest:self.request];
    }
}

- (NSString*)mimeTypeOfPathExtension:(NSString*)pathExtension {
    static NSDictionary* mimeTypes = nil;
    if (mimeTypes == nil) {
        mimeTypes = @{
                      @"png": @"image/png",
                      @"jpg": @"image/jpg",
                      @"jpeg": @"image/jpeg",
                      @"gif": @"image/gif",
                      @"svg": @"image/svg+xml",
                      @"tif": @"image/tiff",
                      @"tiff": @"image/tiff",
                      @"webp": @"image/webp",
                      @"ico": @"image/x-icon",
                      @"m4a": @"audio/mp4a-latm",
                      @"m4v": @"video/x-m4v",
                      @"wav": @"audio/wav",
                      @"aac": @"audio/aac",
                      @"mpeg": @"video/mpeg",
                      @"mp3": @"audio/mp3",
                      @"webm": @"video/webm",
                      @"weba": @"video/webm",
                      @"oga": @"audio/ogg",
                      @"ogv": @"video/ogg",
                      @"avi": @"video/x-msvideo",
                      @"mp4": @"video/mp4",
                      @"m3u8": @"application/x-mpegURL",
                      @"h264": @"video/h264",
                      @"flv": @"video/x-flv",
                      @"ts": @"video/MP2T",
                      @"mov": @"video/quicktime",
                      @"wmv": @"video/x-ms-wmv",
                      @"3gp": @"video/3gpp",
                      @"xml": @"application/xml",
                      @"js": @"application/javascript; charset=utf-8",
                      @"json": @"application/json;charset=utf-8",
                      @"html": @"text/html; charset=utf-8",
                      @"jar": @"application/java-archive",
                      @"woff": @"font/woff",
                      @"ttf": @"application/x-font-ttf",
                      @"otf": @"application/x-font-otf",
                      @"abw": @"application/x-abiword",
                      @"arc": @"application/octet-stream",
                      @"bz": @"application/x-bzip",
                      @"bz2": @"application/x-bzip2",
                      @"csh": @"application/x-csh",
                      @"css": @"text/css",
                      @"csv": @"text/css",
                      @"doc": @"application/msword",
                      @"ics": @"text/calendar",
                      };
    }
    return mimeTypes[pathExtension];
}

@end
