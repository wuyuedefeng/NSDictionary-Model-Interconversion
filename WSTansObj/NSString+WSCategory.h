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

#pragma mark - MD5加密
- (NSString *) ws_md5_encrypt;
#pragma mark - 判断字符串是否不为空(' ',nil,null)
-(BOOL) ws_isNotNilString;
@end
