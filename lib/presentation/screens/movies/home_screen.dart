import 'package:flutter/material.dart';
import 'package:moviedb_app/presentation/views/views.dart';
import 'package:moviedb_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  final int pageIndex;
  static const name = 'home-screen';
  final List<Widget> homeViews = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoritesView()
  ];

  const HomeScreen({super.key, required this.pageIndex});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: homeViews,
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: CustomBottomNavigator(currentIndex: pageIndex,),
    );
  }
}




