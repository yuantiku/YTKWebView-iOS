//
//  NSObject+YTKObject.m
//  YTKWebView
//
//  Created by lihaichun on 2018/12/29.
//

#import "NSObject+YTKObject.h"
#import <objc/runtime.h>

@implementation NSObject (YTKObject)

- (id)ytk_assignObject {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYtk_assignObject:(id)ytk_assignObject {
    objc_setAssociatedObject(self, @selector(ytk_assignObject), ytk_assignObject, OBJC_ASSOCIATION_ASSIGN);
}

- (id)ytk_retainObject {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYtk_retainObject:(id)ytk_retainObject {
    objc_setAssociatedObject(self, @selector(ytk_retainObject), ytk_retainObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ytk_copyObject {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYtk_copyObject:(id)ytk_copyObject {
    objc_setAssociatedObject(self, @selector(ytk_copyObject), ytk_copyObject, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
