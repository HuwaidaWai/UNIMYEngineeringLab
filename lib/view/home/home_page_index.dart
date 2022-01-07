import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/view/home/beacons_screen.dart';
import 'package:smart_engineering_lab/view/home/home_screen.dart';
import 'package:smart_engineering_lab/view/home/lab_booking_screen.dart';
import 'package:smart_engineering_lab/view/home/profile_screen.dart';

class HomePageIndex extends StatefulWidget {
  const HomePageIndex({Key? key}) : super(key: key);

  @override
  _HomePageIndexState createState() => _HomePageIndexState();
}

class _HomePageIndexState extends State<HomePageIndex> {
  int _difference = 0;
  int _bottomSelectedIndex = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    print('Current index : $_bottomSelectedIndex');
    print('Previous index : $index');
    _difference = (index - _bottomSelectedIndex).abs();
    print('Difference : $_difference');
    setState(() {
      _bottomSelectedIndex = index;
      if (_difference == 1) {
        print('Animate sikit');
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 600), curve: Curves.easeOut);
      } else {
        print('JUMP TERUS');
        pageController.jumpToPage(
          index,
        );
      }
    });
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          pageChanged(index);
          //_selectBottomBar(pageKeys[index], index);
        },
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: const [
          HomeScreen(),
          BeaconScreen(),
          LabBookingScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) {
          bottomTapped(val);
        },
        currentIndex: _bottomSelectedIndex,
        items: [
          FloatingNavbarItem(icon: Icons.home),
          FloatingNavbarItem(icon: Icons.list),
          FloatingNavbarItem(icon: Icons.calendar_today),
          FloatingNavbarItem(icon: Icons.account_circle),
        ],
      ),
    );
  }
}
