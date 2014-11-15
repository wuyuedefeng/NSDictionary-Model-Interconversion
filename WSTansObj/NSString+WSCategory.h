//
//  NSString+WSCategory.h
//  Category_Nsobject
//
//  Created by wangsen on 13-12-31.
//  Copyright (c) 2013年 ws. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (Category)
-(BOOL) ws_isNotNilString;
- (CGSize)ws_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (NSUInteger)length;
- (BOOL)isEqualToString:(NSString *)aString;
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;
- (id)jsonObject;
- (int)intValue;
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet;
@end
/***
 *  ///////////////添加ContainsString分类 该方法在ios8才被系统提供 该方法为了向下兼容
 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
@interface NSString (ContainsString)
// Added in iOS 8, retrofitted for iOS 7
- (BOOL)containsString:(NSString *)aString;
@end
#endif
/***
 *  ///////////////
 */
@interface NSString (Category)

- (NSString *)stringByAppendingString_safe:(NSString *)aString;

#pragma mark - 邮件格式是否合法
-(BOOL) ws_isValidate_Email;
#pragma mark -手机号码格式是否合法
-(BOOL) ws_isValidate_Mobile;
#pragma mark -用户名格式是否合法
-(BOOL) ws_isValidate_User;
#pragma mark -验证密码：6—16位，只能包含字符、数字和 下划线。
- (BOOL)ws_isValidate_Password;//验证密码：6—16位，只能包含字符、数字和 下划线。
#pragma mark -是否全为数字
-(BOOL) ws_isValidate_NumberStr;
#pragma mark -是否全为英文
- (BOOL)ws_isValidate_EnglishWords;
#pragma mark -是否全为字母和数字
- (BOOL)ws_isValidate_EnglishWordsAndNumStr;
#pragma mark -是否全为中文
- (BOOL)ws_isValidate_ChineseWords;
#pragma mark -验证是否为网址
- (BOOL)ws_isValidate_InternetUrl;//验证是否为网络链接。
#pragma mark -验证15或18位身份证
- (BOOL)ws_isValidate_IdentifyCardNumber;//验证15或18位身份证。

- (NSString *)ws_URLEncodedString;
- (NSString *)ws_URLDecodedString;

- (NSURL *)ws_URL;
- (NSURL *)ws_fileURL;

#pragma mark - 判断字符串是否不为空(' ',nil,null)
-(BOOL) ws_isNotNilString;

#pragma mark - 获取字符串尺寸
- (CGSize)ws_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)ws_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize addSize:(CGSize)addSize;
#pragma mark - 字符串转换成JSON数据
- (id)jsonObject_ws;

#pragma mark - MD5加密
- (NSString *) ws_md5_encrypt;
#pragma mark - 哈希算法（Secure Hash Algorithm）
//SHA1有如下特性：不可以从消息摘要中复原信息；两个不同的消息不会产生同样的消息摘要。
- (NSString *)ws_SHA1;
#pragma mark - base64加密
- (NSString *)ws_base64_encodeUTF8;
#pragma mark -base64解密
- (NSString *)ws_base64_decodeUTF8;
- (NSData *) ws_base64DataWithBase64String;
@end
