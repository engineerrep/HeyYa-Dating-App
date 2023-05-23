# HeyYa Project Description
[中文版](https://github.com/engineerrep/HeyYa-Dating-App/blob/main/README.md)|English

## 1.Project Introduction
### 1.1Project Overview
HeyYa is a mobile social app developed by the HeyYa team to allow people to connect with others by sharing moments of their daily lives. 
The main interface of HeyYa is a dynamic feed in waterfall form. Users can share photos, short videos and text updates. Users can interact with other users by liking, commenting and sharing. Users can follow interesting people and create their own channels by topics of interest.
HeyYa also has an explore page where users can browse popular topics and channels. The app also has private messaging, stories and live streaming features for more in-depth social interaction.
Overall, HeyYa is an active social platform that encourages users to share every moment of their lives anytime, anywhere. The app uses a simple interface and smooth user experience to build an interactive community where users can connect, share experiences and discover common interests.
(Google Play link:[https://play.google.com/store/apps/details?id=com.heyyateam.heyya](https://play.google.com/store/apps/details?id=com.heyyateam.heyya))
### 1.2Project Features
- A dynamic social feed for sharing life moments - Users can post photos, short videos, and text updates to share what's happening in their lives.
- Interest-based channels - In addition to a general social feed, HeyYa has interest-based channels where users can connect over shared interests and hobbies. Users can create their own channels or follow existing ones.
- Private messaging - HeyYa offers private chat messaging so users can have more personal conversations and build closer relationships.• Live streaming - The live streaming feature allows users to broadcast live video to their followers. Viewers can comment and interact in real-time.
- Stories - HeyYa has "stories" where users can share photo and video updates that disappear after 24 hours. Stories provide a more casual and temporary way to share life moments with followers.• Profile and follow - Users have their own profile where they can describe themselves, post updates and share interests. Users can follow other interesting users to see their updates and connect. 
- Explore page - The explore page allows users to browse trending discussions, popular channels, and people to find new accounts to follow based on common interests.
- Notifications - Users receive notifications when other users like, comment on or share their posts so they can stay engaged with followers and join the conversation
- Saved posts - Users can save posts they like so they can view them again later. Saved posts provide an easy way to keep track of favorite updates from people the user follows.

## 2.Started Quickly

If you want to run and deploy Heyya, please follow the steps below:

##### Architecture Overview
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



###### If the page has only one controller, use GetxController + GetView

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





##### 3. Model class

`模型使用自动生成的插件。在生成文件夹中，没有对代码的入侵。不要在Model类中编写自定义方法。`

<!--GetxController，Class as data definition, business logic processing, network request-->

```dart
// network works like
controller.fetchXXXApi();

// update data
controller.updateXXX();


```

##### 4.Network requests and model operations

```dart
// repository define + impl

// repository lazy loading （Bindings）
```



##### 5. Some methods of obtaining system constants

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



##### 6.Binding 

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

##### 7.Other specifications

- State-related data, using StateMixin？

- Use the FlutterJsonBeanFactory plug-in to avoid intrusion into the code of the model class file, which is not conducive to expansion


## 3. Contribution Guide
Welcome to contribute! HeyYa is an open source project and we appreciate your enthusiastic support.

### 3.2 Asking Questions and Reporting Bugs  
If you have any questions or encounter any errors while using the application, please submit an issue on GitHub. Please provide detailed information about the problem you encountered, along with screenshots or error logs (if any) to help us understand and diagnose the issue.

### 3.3 Feature Requests and Change Suggestions  
If you have any feature requests or change suggestions, please submit an issue on GitHub to explain your ideas and reasons. We welcome and encourage community participation to improve and optimize the application together with us.

## 4.Reference link
[GetX](https://segmentfault.com/a/1190000039139198#item-2-3)

[GetX Cli](https://segmentfault.com/a/1190000040705687)

[Flutter](https://book.flutterchina.club/preface.html#%E7%AC%AC%E4%BA%8C%E7%89%88%E5%8F%98%E5%8C%96)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## 5. Contact Us
Thank you for your support of the HeyYa project. If you have any questions, please contact us via GitHub Issues or by email at [engineerrep@gmail.com](mailto:engineerrep@gmail.com).

