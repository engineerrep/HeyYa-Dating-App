# heyya

A dating app that user should upload video as profile element.



#### 目录说明

```bash
app
├── bindings # Bindings加载
├── core # 常规类
│   ├── enum # 枚举
│   ├── util # 工具类
│   ├── values # 常量
│   └── widget # 基本控件
├── data # 数据
│   ├── local # 本地缓存
│   ├── model # model定义
│   ├── repository # model操作，网络请求
├── flavors # 环境配置，类似xcode的scheme
├── module # 应用模块
├── network # 网络请求
└── routes # 路由

assets # 公共静态资源目录
    ├── images # 图片
    └── json 
    
main_dev.dart  # 开发环境入口文件
main_prod.dart  # 生产环境入口文件
```



#### 一、项目使用第三方框架

###### 总体框架：[GetX](https://www.liujunmin.com/flutter/getx/introduction.html#navigation%E8%B7%AF%E7%94%B1%E8%B7%B3%E8%BD%AC) [4.6.5](https://pub.dev/packages/get)

###### 网络请求：Dio





#### 二、封装/模块



###### <!--封装工具类-->

*Jarry*

- 封装Snackbar、Dialog、BottomSheet （类方法、GetX）

- 封装路由（GetX）

- 主题配置（GetX）

- 字体封装

  

*Jackson*

- 网络请求
- Session、token用户数据

*Brad*

* 图片选取
* 图片获取
* 图片浏览



###### <!--页面-->

```Dart
//Jarry
视频相关

// Jackson
登录页、IM页面、导航栏、常规按钮封装
  
// Brad
Spark
  
```



###### <!--组件化？-->

[链接](https://juejin.cn/post/7006236078218674207)

```Dart
//组件化开发

如果有IM，考虑组件化开发，避免和getx的架构混在一起
```



#### 三、书写规范

##### 1. 响应式使用属性.obs写法，不用使用Rx写法

```dart
// Instantiate
var name = "Ax".obs
  
// Use Obx(()=> to update Text() whenever count is changed.
child: Obx(() => Text(
              "我的名字是 ${name.value}",
              style: TextStyle(color: Colors.red, fontSize: 30),
            )),

// or
child: GetBuilder<GetxController>(
  builder: (controller) {
          return Text()
  })
  
 
// 其它写法 1
ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // same signature! you could use ( newValue ) => updateFn( newValue )
  ),
  // if you need to call something outside the builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),

// 其它写法 2
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),

```



##### 如果页面只有一个控制器，使用 GetxController + GetView ? (代码未测试)

```dart
 class AwesomeController extends GetController {
   final String title = 'My Awesome View';
 }

  // ALWAYS remember to pass the `Type` you used to register your controller!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // just call `controller.something`
       // child: obx(()=> return Text(controller.title)),
     );
   }
 }
```



##### 2. obs Useful tips

```dart
final name = 'GetX'.obs;
// only "updates" the stream, if the value is different from the current one.
name.value = 'Hey';

// All Rx properties are "callable" and returns the new value.
// but this approach does not accepts `null`, the UI will not rebuild.
name('Hello');

// is like a getter, prints 'Hello'.
name() ;

/// numbers:

final count = 0.obs;

// You can use all non mutable operations from num primitives!
count + 1;

// Watch out! this is only valid if `count` is not final, but var
count += 1;

// You can also compare against values:
count > 2;

/// booleans:

final flag = false.obs;

// switches the value between true/false
flag.toggle();


/// all types:

// Sets the `value` to null.
flag.nil();

// All toString(), toJson() operations are passed down to the `value`
print( count ); // calls `toString()` inside  for RxInt

final abc = [0,1,2].obs;
// Converts the value to a json Array, prints RxList
// Json is supported by all Rx types!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList and RxSet are special Rx types, that extends their native types.
// but you can work with a List as a regular list, although is reactive!
abc.add(12); // pushes 12 to the list, and UPDATES the stream.
abc[3]; // like Lists, reads the index 3.


// equality works with the Rx and the value, but hashCode is always taken from the value
final number = 12.obs;
print( number == 12 ); // prints > true

/// Custom Rx Models:

// toJson(), toString() are deferred to the child, so you can implement override on them, and print() the observable directly.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` is "reactive", but the properties inside ARE NOT!
// So, if we change some variable inside of it...
user.value.name = 'Roi';
// The widget will not rebuild!,
// `Rx` don't have any clue when you change something inside user.
// So, for custom classes, we need to manually "notify" the change.
user.refresh();

// or we can use the `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );
```





##### 3. Model类

`Model使用自动生成插件，在generation文件夹内，对代码没入侵，Model类里面不要写自定义方法`

<!--GetxController，作为数据定义、业务逻辑处理、网络请求的类-->

```dart
// 网络请求写法 
controller.fetchXXXApi();

// 更新数据
controller.updateXXX();


```

##### 4. 网络请求和model操作

```dart
// repository 定义 + impl

// repository懒加载 （Bindings）
```



##### 5. 一些系统常量获取方法 

```dart
//Check in what platform the app is running
GetPlatform.isAndroid
GetPlatform.isIOS
  
  // Equivalent to : MediaQuery.of(context).size.height,
// but immutable.
Get.height
Get.width

// Gives the current context of the Navigator.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
Get.contextOverlay

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context.
context.width
context.height

```



##### 6. Binding写法

`使用Binding初始化所有Controller，解决重复初始化问题`

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// GetX Binding
    return GetMaterialApp(
      title: "GetX",
      initialBinding: AllControllerBinding(),
      home: GetXBindingExample(),
    );
  }
}


class AllControllerBinding implements Bindings {
  
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<BindingMyController>(() => BindingMyController());
    Get.lazyPut<BindingHomeController>(() => BindingHomeController());
  }
}



```



##### 7. 其它规范

* 状态相关的数据，使用 StateMixin？

* 使用 FlutterJsonBeanFactory插件，避免对model类文件代码入侵，不利扩展 （Json to dart

* ~~使用 flutterassetautocompletion插件（图片资源路径补全~~

#### 四、链接



[GetX插件](https://segmentfault.com/a/1190000039139198#item-2-3)

[GetX Cli](https://segmentfault.com/a/1190000040705687)

[Flutter实战·第二版](https://book.flutterchina.club/preface.html#%E7%AC%AC%E4%BA%8C%E7%89%88%E5%8F%98%E5%8C%96)





# 



This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
