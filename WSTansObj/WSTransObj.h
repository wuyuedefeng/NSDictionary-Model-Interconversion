//
//  WSTransObj.h
//  test_predicate
//
//  Created by wangsen on 14-7-15.
//  Copyright (c) 2014年 wangsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@class WSObject;
@interface WSTransObj : WSObject


#pragma mark - 获取与设置值
#pragma mark -获取值
+ (id)valueGetterOfModal:(id)modal withKey:(NSString *)key;
#pragma mark -设置值
+ (void)valueSetterOfModal:(id)modal withKey:(NSString *)key withValue:(NSString *)value;

#pragma mark - 模型转换
#pragma mark -字典数组转模型数组
+ (NSArray *)modalArray_from_dictionaryArr:(NSArray *)dictionaryArr;
+ (NSArray *)modalArray_from_dictionaryArr:(NSArray *)dictionaryArr token:(NSString*)token;
+ (id)modal_from_dictionary:(NSDictionary *)dic;
+ (id)modal_from_dictionary:(NSDictionary *)dic token:(NSString*)token;
#pragma mark -模型数组转字典数组
+ (NSArray *)dictionaryArray_from_modalArray:(NSArray *)modolArray;
+ (id)dictionary_from_modal:(id)modol;

+ (id)modalFromToken:(NSString *)token;
+ (void)removeToken:(NSString *)token;
+ (void)removeAllToken;


#pragma mark - 获取模型的值
- (id)valueForKey:(NSString *)key;
#pragma mark - 设置模型的值
- (void)setValue:(id)value forKey:(NSString *)key;
@end
