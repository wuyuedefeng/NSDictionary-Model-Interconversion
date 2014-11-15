//
//  NSString+WSCategory.m
//  Category_Nsobject
//
//  Created by wangsen on 13-12-31.
//  Copyright (c) 2013年 ws. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+WSCategory.h"
#import <objc/runtime.h>
@implementation NSNull (Category)
-(BOOL) ws_isNotNilString
{
    return NO;
}
@end
/***
 *  ///////////////添加ContainsString分类 该方法在ios8才被系统提供 该方法为了向下兼容
 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
@implementation NSString (ContainsString)
+ (void)load {
    @autoreleasepool {
        [self pspdf_modernizeSelector:NSSelectorFromString(@"containsString:") withSelector:@selector(containsString:)];
    }
}
+ (void)pspdf_modernizeSelector:(SEL)originalSelector withSelector:(SEL)newSelector {
    if (![NSString instancesRespondToSelector:originalSelector]) {
        Method newMethod = class_getInstanceMethod(self, newSelector);
        class_addMethod(self, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    }
}
// containsString: has been added in iOS 8. We dynamically add this if we run on iOS 7.
- (BOOL)containsString:(NSString *)aString {
    return [self rangeOfString:aString].location != NSNotFound;
}
@end

#endif
/**
 *  /////////////////////
 */
@implementation NSString (Category)
#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *) ws_md5_encrypt
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString copy];
}

#pragma mark - 判断字符串是否不为空(' ',nil,null)
/**
 *  判断字符串是否不为空 包括(' ',nil,null)
 *
 *  @return 如果不是(' ',nil,null)返回YES
 */
-(BOOL) ws_isNotNilString
{
    if(self != nil && ![self isEqual:[NSNull null]] && self.length != 0 && ![[self lowercaseString] isEqualToString:@"(null)"])
    {
        return YES;
    }
    return NO;
}
@end
