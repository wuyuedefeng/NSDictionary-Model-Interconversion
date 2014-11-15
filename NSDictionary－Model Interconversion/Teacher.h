//
//  Teacher.h
//  WSFouncDesign
//
//  Created by TX-009 on 14-8-28.
//  Copyright (c) 2014年 TX-009. All rights reserved.
//

#import "Person.h"
#import "Name.h"
@interface Teacher : Person
@property (nonatomic,strong)Name *nameModal;
@property (nonatomic,copy)NSString *teacherAge;
@property (nonatomic,copy)NSNumber *teacherAge2;
@end
