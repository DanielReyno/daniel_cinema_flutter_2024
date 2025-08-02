import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigator extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNavigator({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index){
    context.go("/home/$index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) {
        onItemTapped(context, value);
      },
      elevation: 0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline_sharp), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: "Favorites")
      ]
      );
  }
}