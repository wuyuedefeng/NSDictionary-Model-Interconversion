
## 前言

网络解析json数据都是以字典的形式，我们有时候需要将json数据转换成model，显的特别麻烦，尤其是字典数组，或者字典中还有嵌套字典。  后者对象中包含对象想转换成NSDictionary字典时，也是特别麻烦。  
为了解决这类问题，本人特意封装了一套 字典模型数组－模型数组的深层转换 来解决这类问题，方便开发，为了给ios开发着带来方便，特意贡献出来，和大家分享，如有更好的改进意见，请联系本人邮箱 swfeiyang@gmail.com

## iOS端的尝试

对字典转换成模型可以使用默认方式，或者创建时候同时传入token值，token创建类的标识，通过token可以获得一个model新对象，然后对新对象进行数据操作等。  NSDictionary类的条件key－value键值对 的value值可以为NSString、NSNumber、甚至是NSDictionary类型。 当对象字典内部key的value值还是字典时，该value转化后的model对象的token就是该字典对应的key值。
转换后的模型支持系统相同方法，valueForKey:，seValueForKey:，和平时操作自己创建的类使用赋值方法完全相同（小缺点：由于使用基类对象作为后者对象的类型，所有不支持点语法，所以请使用valueForKey:，seValueForKey:）

## 开源

经过几个月的使用和测试，我认为它非常好用，而且代码也非常简单。所以现在开源分享给大家，以下是使用说明，结果查看，请下载源码，希望大家能够多多支持。您的小小的支持，就是我莫大的动力。
以下是用法介绍：

```
`+ (id)modal_from_dictionary:(NSDictionary *)dic;`是将字典转换成模型（支持字典里面包含字典的深度转寒）
`+ (id)modal_from_dictionary:(NSDictionary *)dic token:(NSString*)token;`是将字典转换成模型，并添加token
`+ (id)modalFromToken:(NSString *)token;`使用token创建一个新的对象model
`+ (void)removeToken:(NSString *)token;`移除某个token
`+ (void)removeAllToken;`移除所有token

```
`+ (id)dictionary_from_modal:(id)modol`将模型队形转换成字典（支持对象的继承和包含转换）


```
在这里举例说明使用字典数组<->model数组之间的相互转化：
Teacher是一个类继承自Person类，Person类含有属性teacherAge，Name（也是一个类）是Tearcher类中包含的一个属性，Name类中包含属性nameCStr，以下是使用方法演示
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
通过`modalArray_from_dictionaryArr:`方法，可以讲模型转换成字典，以后如果不需要创建新的model对象，该地方token可以不传，如下所示：
arr = [WSTransObj modalArray_from_dictionaryArr:dicArr];
dicArr = [WSTransObj dictionaryArray_from_modalArray:arr];
NSLog(@"没有token：%@",dicArr);

通过`modalArray_from_dictionaryArr:token:`方法，可以讲模型转换成字典，token为以后创建一个新的model做标识，如下所示：
arr = [WSTransObj modalArray_from_dictionaryArr:dicArr token:@"WS"];
dicArr = [WSTransObj dictionaryArray_from_modalArray:arr];
NSLog(@"有token：%@",dicArr);

上面传入token在这里可以使用`modalFromToken:`创建创建一个新的model对象(在这里相当于创建了一个Teacher类),然后对新对象赋值，如下所示：
WSTransObj *modal2 = [WSTransObj modalFromToken:@"WS"];
[modal2 setValue:@"111" forKey:@"teacherAge"];

[WSTransObj removeToken:@"WS"];//以后不再使用该token可移除


该处是取得Teacher类中包含的Name类的对象，并对其赋值
id modal3 = [modal2 valueForKey:@"nameModal"];
[modal3 setValue:@"abc" forKey:@"nameCStr"];
modal3 = [modal2 valueForKey:@"nameModal"];
NSDictionary *wsDic = [WSTransObj dictionary_from_modal:modal2];
NSLog(@"%@",wsDic);


## 其它

上面只是做了基本使用介绍，以后有新需求会继续更新，如有好的建议或意见，或技术交流，请联系我。
