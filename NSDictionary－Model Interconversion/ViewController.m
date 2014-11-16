//
//  ViewController.m
//  NSDictionary－Model Interconversion
//
//  Created by senwang on 14/11/15.
//  Copyright (c) 2014年 senwang. All rights reserved.
//

#import "ViewController.h"
#import "Teacher.h"
#import "WSTransObj.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Teacher *tea1 = [[Teacher alloc] init];
    tea1.teacherAge = @10;
    Name *nam1 = [[Name alloc] init];
    nam1.nameCStr = @"namename1";
    tea1.nameModal = nam1;
    
    Teacher *tea2 = [[Teacher alloc] init];
    tea2.teacherAge = @20;
    Name *nam2 = [[Name alloc] init];
    nam2.nameCStr = @"namename2";
    tea2.nameModal = nam2;

    NSArray *arr = [NSArray arrayWithObjects:tea1,tea2, nil];
    NSArray *dicArr = [WSTransObj dictionaryArray_from_modalArray:arr];
    NSLog(@"%@",dicArr);
    NSLog(@"%@",dicArr[0][@"teacherAge"]);

    ///////=================================
    
    arr = [WSTransObj modalArray_from_dictionaryArr:dicArr];
    dicArr = [WSTransObj dictionaryArray_from_modalArray:arr];
    NSLog(@"没有token：%@",dicArr);
    
    
    arr = [WSTransObj modalArray_from_dictionaryArr:dicArr token:@"WS"];
    dicArr = [WSTransObj dictionaryArray_from_modalArray:arr];
    NSLog(@"有token：%@",dicArr);


    WSTransObj *modal2 = [WSTransObj modalFromToken:@"WS"];
    [modal2 setValue:@"111" forKey:@"teacherAge"];
    
    [WSTransObj removeToken:@"WS"];//以后不再使用该token可移除



    id modal3 = [modal2 valueForKey:@"nameModal"];
    [modal3 setValue:@"abc" forKey:@"nameCStr"];
    modal3 = [modal2 valueForKey:@"nameModal"];
    NSDictionary *wsDic = [WSTransObj dictionary_from_modal:modal2];
    NSLog(@"%@",wsDic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
