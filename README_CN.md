# HeyYa项目说明
[English](https://github.com/engineerrep/HeyYa-Dating-App/blob/main/README.md)|中文版

#### 我们提供免费的后端支持，除非您要求定制功能。如果您是一名前端工程师，您可以免费且仅花费几个小时便能将这个安卓应用程序上线。

#### 请通过 GitHub Issues 或通过电子邮件[engineerrep@gmail.com](mailto:engineerrep@gmail.com)与我们联系。

## 1.项目简介
### 1.1项目概述 
Heyya是一款创新的在线约会应用程序，最大的特点是所有用户都是真实的人。每个用户在注册过程中必须通过自拍上传真实照片并验证他们的电话号码。

Heyya致力于为用户提供真诚和安全的约会环境，帮助他们在现实生活中扩展社交圈，建立稳定的关系并找到合适的伴侣。

Heyya使用大数据算法为每个用户推荐最合适的匹配。

Heyya简洁的界面和流畅的用户体验为用户提供了一个互动平台，他们可以在这里建立联系，分享经验并发现共同兴趣。

Heyya致力于创建一个强调单身人士之间真诚互动和理解重要性的积极约会平台。

(Google Play链接:https://play.google.com/store/apps/details?id=com.heyyateam.heyya)
### 1.2项目特点 
1. 100%真实用户 
Heyya要求用户上传真实头像和验证手机号码,以确保每个用户都是真实用户,让用户感到更加安全。 
2. 人工智能推荐 
Heyya利用数据算法为每个用户推荐最合适的圈子和潜在好友,满足用户的个性需求。
3. 正面社交 
Heyya更加注重人与人之间真诚的互动和理解,营造一个积极正面的约会平台。  
4. 形成正向循环 
Heyya以100%真实用户的社交体验吸引更多用户加入,创造正向循环效应,迅速增加用户数量。

## 2.快速开始

要运行和部署 Heyya，请按照以下步骤操作：

##### 架构简介
```bash
app
├── bindings # Bindings
├── core # tool class for basic business
│   ├── enum # 
│   ├── util # 
│   ├── values # 
│   └── widget # 
├── data # data model and repository
│   ├── local # 
│   ├── model # 
│   ├── repository #
├── flavors # environment configuration
├── module # app pages
├── network # network
└── routes # 

assets # 
    ├── images # 
    └── json 
    
main_dev.dart  # Development environment entry file
main_prod.dart  # Production environment entry file


#### 1、The project uses a third-party framework

###### GetX (https://www.liujunmin.com/flutter/getx/introduction.html#navigation%E8%B7%AF%E7%94%B1%E8%B7%B3%E8%BD%AC) [4.6.5](https://pub.dev/packages/get)

###### Network：Dio


#### 2、Package/Module

###### <!--Packaging tools-->

- Package Snackbar、Dialog、BottomSheet （Class method、GetX）
- Routes（GetX）
- Theme（GetX）
- Fonts
- Network
- Session,Account and User
- Albums
- Albums for uploading



###### <!--Componentization-->

[Link](https://juejin.cn/post/7006236078218674207)

```Dart
If there is IM, consider componentized development and avoid mixing with getx architecture



#### 3、Coding style

##### 1. Responsive use attribute .obs writing method instead of Rx writing method

```dart
// Instantiate
var name = "Ax".obs
  
// Use Obx(()=> to update Text() whenever count is changed.
child: Obx(() => Text(
              "My name is ${name.value}",
              style: TextStyle(color: Colors.red, fontSize: 30),
            )),

// or
child: GetBuilder<GetxController>(
  builder: (controller) {
          return Text()
  })
  
 
// or 1
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

// or 2
ObxValue((data) => Switch(
        value: data.value,
        onChanged: data, // Rx has a _callable_ function! You could use (flag) => data.value = flag,
    ),
    false.obs,
),

```



###### 如果页面只有一个控制器，则使用GetxController+GetVIEW

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
##### 2. 有用的提醒

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





##### 3. 模型类

`模型使用自动生成的插件。在生成文件夹中，没有对代码的入侵。不要在Model类中编写自定义方法。`

<!--GetxController，Class as data definition, business logic processing, network request-->

```dart
// network works like
controller.fetchXXXApi();

// update data
controller.updateXXX();


```

##### 4.网络请求和模型操作

```dart
// repository define + impl

// repository lazy loading （Bindings）
```



##### 5. 求得系统常数的几种方法

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



##### 6.绑定

`Use Binding to initialize all Controllers to solve the problem of repeated initialization`

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

##### 7. 其他规范

- 国家相关数据，使用StateMixin？
  
- 使用FlutterJsonBeanFactory插件，避免干扰到模型类文件的代码，这不利于扩展。

## 3.贡献指南
欢迎大家参与贡献！HeyYa 是一个开源项目，感谢各位的热情支持。

### 3.1提问和提交Bug报告  
如果您在使用应用程序的过程中遇到任何疑问或错误，请在 GitHub中提交Issue。请详细说明您遇到的问题，并提供截屏或错误日志(如果有)以帮助我们理解和诊断问题。
### 3.2功能请求和变更建议   
如果您有任何功能请求或变更建议，请在GitHub提交Issue说明您的想法及理由。我们欢迎和鼓励社区参与，与我们一起改进和优化应用程序。

## 4.参考链接
[GetX](https://segmentfault.com/a/1190000039139198#item-2-3)

[GetX Cli](https://segmentfault.com/a/1190000040705687)

[Flutter](https://book.flutterchina.club/preface.html#%E7%AC%AC%E4%BA%8C%E7%89%88%E5%8F%98%E5%8C%96)
这是一个Flutter应用程序的起点。  
如果这是您的第一个Flutter项目,以下是一些入门资源:  
•[实验室:编写您的第一个 Flutter 应用程序](https://book.flutterchina.club/codelab/first_flutter_app.html)  
•[菜谱:有用的Flutter示例](https://book.flutterchina.club/cookbook/index.html)  
有关开始Flutter开发的帮助,请查看[在线文档](https://flutterchina.club/),其中提供教程,示例,移动开发指南和完整的API参考。

## 5.联系我们
感谢您对 HeyYa 项目的支持。如有任何疑问,请通过 GitHub Issues 或通过电子邮件[engineerrep@gmail.com](mailto:engineerrep@gmail.com)与我们联系。

## 6.隐私政策
我们非常重视用户的隐私，我们可能会收集一些数据活跃信息，如贡献者、下载量、活跃度等，以便更好地了解项目的使用情况和改进项目。但我们不会收集用户的具体信息，如姓名、电子邮件地址、IP地址等。我们承诺保护用户的隐私，不会将用户的个人信息泄露给第三方。如果您有任何关于隐私政策的问题或疑虑，请联系我们[engineerrep@gmail.com](mailto:engineerrep@gmail.com)。
