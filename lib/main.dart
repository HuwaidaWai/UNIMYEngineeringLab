import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_engineering_lab/LoginScreen.dart';
import 'package:smart_engineering_lab/requirement_state_controller.dart';
import 'package:smart_engineering_lab/view/collapsing_navigation_drawer.dart';
import 'package:smart_engineering_lab/view/home_page.dart';
import 'package:smart_engineering_lab/custom_navigation_drawer.dart';


Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    Get.put(RequirementStateController());
    Map<int, Color> color =
    {
      50:Color.fromRGBO(136,14,79, .1),
      100:Color.fromRGBO(136,14,79, .2),
      200:Color.fromRGBO(136,14,79, .3),
      300:Color.fromRGBO(136,14,79, .4),
      400:Color.fromRGBO(136,14,79, .5),
      500:Color.fromRGBO(136,14,79, .6),
      600:Color.fromRGBO(136,14,79, .7),
      700:Color.fromRGBO(136,14,79, .8),
      800:Color.fromRGBO(136,14,79, .9),
      900:Color.fromRGBO(136,14,79, 1),
    };

    MaterialColor colorCustom = MaterialColor(0xffd10e48, color);
    final themeData = Theme.of(context);
    final primary = Color(0xffd10e48);
    return MaterialApp(
      title: 'UNIMY ENGINEERING LAB',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: colorCustom,
        appBarTheme: themeData.appBarTheme.copyWith(
          brightness: Brightness.light,
          elevation: 0.5,
          color: Color(0xffd10e48),
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
     home: const MyHomePage(title: 'UNIMY ENGINEERING LAB'),
     // home: HomePage(),
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
      //drawer: CollapsingNavigationDrawer(),
      body: Stack(
        children: <Widget>[
          Container(color:Colors.white),
          CollapsingNavigationDrawer()
        ],
        /*child: RaisedButton(
          child: Text('Login'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),*/
      ),
    );
  }
}

