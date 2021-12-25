import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_engineering_lab/LoginScreen.dart';
import 'package:smart_engineering_lab/requirement_state_controller.dart';
import 'package:smart_engineering_lab/view/home_page.dart';


Future<void> main() async {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    Get.put(RequirementStateController());

    final themeData = Theme.of(context);
    final primary = Colors.red;
    return MaterialApp(
      title: 'UNIMY ENGINEERING LAB',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: primary,
        appBarTheme: themeData.appBarTheme.copyWith(
          brightness: Brightness.light,
          elevation: 0.5,
          color: Colors.white,
          actionsIconTheme: themeData.primaryIconTheme.copyWith(
            color: primary,
          ),
          iconTheme: themeData.primaryIconTheme.copyWith(
            color: primary,
          ),
          textTheme: themeData.primaryTextTheme.copyWith(
            headline6: themeData.textTheme.headline6?.copyWith(
              color: primary,
            ),
          ),
        ),
      ),
     //home: const MyHomePage(title: 'UNIMY ENGINEERING LAB'),
      home: HomePage(),
     debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Login'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
    );
  }
}

