import 'package:flutter/material.dart';

class NavigationModel{
  String title;
  IconData icon;

  NavigationModel({required this.title, required this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Dashboard", icon: Icons.insert_chart),
  NavigationModel(title: "Profile", icon: Icons.verified_user),
  NavigationModel(title: "Lab Module", icon: Icons.pageview),
  NavigationModel(title: "Attendance", icon: Icons.list),
  NavigationModel(title: "Settings", icon: Icons.settings),
];

