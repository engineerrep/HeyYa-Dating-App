# HeyYa项目说明
[English](https://github.com/engineerrep/HeyYa-Dating-App/blob/main/README.md)|中文版

## 1.项目简介
### 1.1项目概述
Heyya是一款移动社交应用。它由Heyya团队开发,旨在让人们通过分享生活中的日常瞬间与他人建立联系。
Heyya的主界面是瀑布流形式的动态 feed。用户可以分享照片、短视频和文本更新。用户可以通过点赞、评论和转发与其他用户互动。用户可以关注感兴趣的人,并按兴趣话题创建自己的频道。
Heyya还有一个探索页面,用户可以浏览热门话题和频道。该应用还具有私信、故事和直播功能,可以进行更深入的社交互动。
整体而言,Heyya是一款活跃的社交平台,鼓励用户随时随地分享生活的每一刻。该应用使用朴素的界面和流畅的用户体验来构建一个互动社区,用户可以在上面建立联系,分享经历,并发现共同的兴趣爱好。
（Google Play链接：https://play.google.com/store/apps/details?id=com.heyyateam.heyya ）
### 1.2项目特点
1. 动态社交feed：Heyya的核心功能是瀑布流式的动态社交feed,让用户分享生活中的照片、短视频和生活更新。用户可以随时上传帖子,并与其他用户互动。
2. 关注和频道:用户可以关注感兴趣的朋友和话题频道。频道内容由用户社区生成,涵盖各种话题。这使得发现共同兴趣的用户和内容变得容易。
3. 私信和直播:Heyya不仅有社交feed,还提供私人交流的方式。用户可以通过私信进行即时通讯。Heyya也有直播功能,用户可以通过手机直播与他人互动。 
4. 探索页面:Heyya有一个探索页面,高亮展示热门话题、频道和用户。这使新用户更容易找到自己感兴趣的内容和社区。
5. 故事功能:Heyya允许用户创建故事,将多张照片和视频组合在一起,讲述一段生活经历或者一个项目进展。这种新的内容形式鼓励用户与他人分享更加连贯的故事。
6. obtaining粉丝和影响力:与其他社交平台一样,Heyya也有粉丝和影响力机制。用户可以通过产生受欢迎的内容和互动来获得更高的粉丝和影响力。

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

