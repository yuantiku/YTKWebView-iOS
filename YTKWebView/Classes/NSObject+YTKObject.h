//
//  NSObject+YTKObject.h
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YTKObject)

@property (nonatomic, assign, nullable) id ytk_assignObject;

@property (nonatomic, strong, nullable) id ytk_retainObject;

@property (nonatomic,   copy, nullable) id ytk_copyObject;

@end

NS_ASSUME_NONNULL_END
