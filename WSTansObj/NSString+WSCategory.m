//
//  NSString+WSCategory.m
//  Category_Nsobject
//
//  Created by wangsen on 13-12-31.
//  Copyright (c) 2013年 ws. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+WSCategory.h"
#import "NSData+WSCategory.h"
#import <objc/runtime.h>
@implementation NSNull (Category)
-(BOOL) ws_isNotNilString
{
    return NO;
}
- (CGSize)ws_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return CGSizeZero;
}
- (NSUInteger)length
{
    return 0;
}
- (BOOL)isEqualToString:(NSString *)aString
{
    return false;
}
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    return @"";
}
- (id)jsonObject
{
    return nil;
}
- (int)intValue
{
    return 0;
}
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet
{
    return NSMakeRange(0,0);
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

- (NSString *)stringByAppendingString_safe:(NSString *)aString
{
    if ([aString ws_isNotNilString]) {
      return  [self stringByAppendingString:aString];
    }
    return self;
}






-(BOOL)ws_isValidate_Email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateFromPredicateRegex:emailRegex];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) ws_isValidate_Mobile
{
    NSString *phoneNum = self;
    if ([self hasPrefix:@"+86"]) {
       phoneNum = [self substringFromIndex:3];
    }
    if ([self hasPrefix:@"86"]) {
       phoneNum = [self substringFromIndex:2];
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    return [phoneNum isValidateFromPredicateRegex:phoneRegex];
}
//判断用户名是否有效
-(BOOL) ws_isValidate_User
{
    NSInteger length= [self length];

    if (length<6 || length>20) {
        return NO;
    }
    for (int i=0; i<length; i++) {
        char ch=[self characterAtIndex:i];
        if ((ch>='0'&&ch<='9') || (ch>='a'&&ch<='z') || (ch>='A'&&ch<='Z') || ch=='_') {
            continue;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}
//字母数字下划线，6－16位
- (BOOL)ws_isValidate_Password
{
    NSString *regex = @"^[\\w\\d_]{6,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
#pragma mark -是否为数字
-(BOOL) ws_isValidate_NumberStr
{
    NSString *regex = @"^[0-9]*$";
    return [self isValidateFromPredicateRegex:regex];
}
#pragma mark -是否为英文
- (BOOL)ws_isValidate_EnglishWords
{
    NSString *regex = @"^[A-Za-z]+$";
    return [self isValidateFromPredicateRegex:regex];
}
#pragma mark -是否全为字母和数字
- (BOOL)ws_isValidate_EnglishWordsAndNumStr
{
    NSString *regex = @"[a-z][A-Z][0-9]";
    return [self isValidateFromPredicateRegex:regex];
}
#pragma mark -是否全为中文
/**
 *  是否字符串全部位中文
 *
 *  @return <#return value description#>
 */
- (BOOL)ws_isValidate_ChineseWords
{
//    NSString *regex = @"^[\u4e00-\u9fa5],{0,}$";//测试只能获得单个汉字的结果是否为中文
//    return [self isValidateFromPredicateRegex:regex];
    for (int i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        const char *cString = [[self substringWithRange:range] UTF8String];
        if (strlen(cString) != 3) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)ws_isValidate_InternetUrl
{
    NSString *regex = @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$ ；^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
//15或者18位身份证
- (BOOL)ws_isValidate_IdentifyCardNumber
{
    NSString *regex = @"^\\d{15}|\\d{}18$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
- (BOOL)isValidateFromPredicateRegex:(NSString *)regex
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:self];
}


/**
 *  @brief URL编码
 */
- (NSString *)ws_URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease
    (CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                             (CFStringRef)self,
                                             NULL,
                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                             kCFStringEncodingUTF8));
    return result;
}

/**
 *  @brief URL解码
 */
- (NSString *)ws_URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease
    (CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                             (CFStringRef)self,
                                                             CFSTR(""),
                                                             kCFStringEncodingUTF8));
    return result;
}
/**
 *  @brief URL
 */
- (NSURL *)ws_URL
{
    return [NSURL URLWithString:self];
}

/**
 *  @brief 文件URL
 */
- (NSURL *)ws_fileURL
{
    return [NSURL fileURLWithPath:self];
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
#pragma mark - 获取字符串尺寸
/**
 *  计算文字尺寸
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 *  maxSize 限制计算文字的最大宽度和高度 如果宽度设置100 高度设置为MAXFLOAT 则返回文字宽度最大100 高度无限制的所输入文字的尺寸
 */
- (CGSize)ws_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}
- (CGSize)ws_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize addSize:(CGSize)addSize
{
    CGSize tmpSize = [self ws_sizeWithFont:font maxSize:maxSize];
    return CGSizeMake(tmpSize.width + addSize.width, tmpSize.height + addSize.height);
}
#pragma mark - 字符串转换成JSON数据
/**
 *  将json字符串 解析成 id 类型
 *
 *  @return 返回解析后的数据
 */
- (id)jsonObject_ws
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error || [NSJSONSerialization isValidJSONObject:result] == NO)
        return nil;
    return result;
}
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
#pragma mark - 哈希算法（Secure Hash Algorithm）
//SHA1有如下特性：不可以从消息摘要中复原信息；两个不同的消息不会产生同样的消息摘要。
/**
 *  哈希算法（Secure Hash Algorithm）
 *
 *  @return <#return value description#>
 */
- (NSString *)ws_SHA1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	return [data ws_SHA1];
}
#pragma mark - base64加密
/**
 *  base64加密 － 将字符串以UTF8编码方式转化为base64字符串
 *
 *  @return 转化后到base64字符串
 */
- (NSString *)ws_base64_encodeUTF8
{
    if ([self isEqualToString:@""] || self == nil) {
        return self;
    }
    //base64编码
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
#pragma mark -base64解密
/**
 *  base64解密 － 将UTF8编码方式的base64加密的字符串转换成普通字符串
 *
 *  @return base64解密后的字符串
 */
- (NSString *)ws_base64_decodeUTF8
{
    if ([self isEqualToString:@""] || self == nil) {
        return self;
    }
    //base64解密
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
/**
 *  base64加密 － Returns a new data contained in the Base64 encoded string.
 *  本身的字符串是base64字符串 返回的data是base64编码的data
 *  编码：NSASCIIStringEncoding
 *  @return Data contained in `base64String`
 */
- (NSData *) ws_base64DataWithBase64String
{
    //self是base64加密字符串
    return [NSData ws_dataWithBase64String:self];
}

@end
