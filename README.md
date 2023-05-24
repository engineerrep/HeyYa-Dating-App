# HeyYa Project Introduction
English|[中文版](https://github.com/engineerrep/HeyYa-Dating-App/blob/main/README_CN.md)

## 1. Project Overview
### 1.1 Project Description
Heyya is an online dating app targeted towards young people. Its biggest feature is its 100% authentic users. During registration, users must upload real photos and verify their phone numbers to ensure that every user is a real person.

Heyya is committed to creating a sincere and safe social environment. Users can meet new friends, build stable relationships, and even find suitable partners through Heyya. 

Heyya uses big data algorithms to recommend the most suitable dating partners to each user. Heyya's user base is eager to meet more interesting people through mobile internet and expand their social circles in real life.

Heyya encourages users to share every moment of their life anytime, anywhere. The app uses a simple interface and smooth user experience to build an interactive community where users can connect with each other, share experiences, and discover common interests. 

Through its 100% authentic user social experience, Heyya attracts more young users to join, forming a positive loop. In Heyya, sincere interaction and understanding between people are especially important. This also makes Heyya a dating platform that cultivates optimistic and positive young people.

(Google Play link: https://play.google.com/store/apps/details?id=com.heyyateam.heyya)

### 1.2 Project Features
1. 100% Authentic Users 
Heyya requires users to upload genuine profile pictures and verify their phone numbers during registration, ensuring that each user is a real individual. This makes users feel more secure and trustworthy, avoiding being deceived. 

2. Artificial Intelligent Recommendations 
Heyya uses artificial intelligence and big data algorithms to recommend the most suitable social circles and potential friends for each user. These recommendations are more accurate and personalized, helping users quickly find people they are interested in.

3. Positive Energy Socialization  
Unlike other dating apps, Heyya places more importance on sincere interaction, communication, and understanding between people. This makes Heyya a social platform that cultivates optimistic and positive young people.

4. Targeted Towards Young People 
Heyya's target user group is young people who are eager to meet more new friends and expand their social circles in real life through mobile internet. Heyya is designed to meet this user demand.

5. Positive Loop Effect 
Heyya's 100% authentic user social experience attracts more users to join, and more new authentic users will also be attracted. This positive loop effect allows Heyya's user base to rapidly grow.


## 2. Getting Started

To run and deploy Heyya, follow these steps:

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

##### 7. Other Specifications

- For national related data, use StateMixin?

- Use the FlutterJsonBeanFactory plugin to avoid interfering with the code in model class files, which is not conducive to expansion.

## 3. Contribution Guidelines

We welcome your contribution to HeyYa, an open-source project. Thank you for your enthusiastic support.

### 3.1 Asking Questions and Submitting Bug Reports

If you have any questions or encounter any errors while using the application, please submit an issue on GitHub. Please provide a detailed description of the problem you encountered and provide screenshots or error logs (if available) to help us understand and diagnose the problem.

### 3.2 Feature Requests and Change Suggestions

If you have any feature requests or change suggestions, please submit an issue on GitHub to describe your ideas and reasons. We welcome and encourage community participation to improve and optimize the application.

## 4. Reference Links

[GetX](https://segmentfault.com/a/1190000039139198#item-2-3)

[GetX Cli](https://segmentfault.com/a/1190000040705687)

[Flutter](https://book.flutterchina.club/preface.html#%E7%AC%AC%E4%BA%8C%E7%89%88%E5%8F%98%E5%8C%96)

This is the starting point for a Flutter application. If this is your first Flutter project, here are some introductory resources:

•[Codelab: Write Your First Flutter App](https://flutter.dev/docs/get-started/codelab)

•[Cookbook: Useful Flutter Samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter development, please refer to the [online documentation](https://flutter.dev/docs), which provides tutorials, examples, mobile development guides, and a complete API reference.

## 5. Contact Us

Thank you for your support of the HeyYa project. If you have any questions, please contact us through GitHub Issues or by email at [engineerrep@gmail.com](mailto:engineerrep@gmail.com).

## 6. Privacy Policy

We value the privacy of our users. We may collect some data on user activity, such as contributors, download counts, and activity levels, to better understand how the project is being used and improved. However, we do not collect specific user information, such as names, email addresses, or IP addresses. We promise to protect the privacy of our users and not disclose their personal information to third parties. If you have any questions or concerns about the privacy policy, please contact us at [engineerrep@gmail.com](mailto:engineerrep@gmail.com).

