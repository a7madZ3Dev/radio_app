import 'package:flutter/material.dart';
import 'package:radio_app/pages/radio_page.dart';

import './fav_radios_page.dart';
import '../utils/hex_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = const [
    RadioPage(isFavoriteOnly: false),
    FavRadiosPage(),
  ];

  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<BottomNavigationBarItem> getBottomNavBarList() {
    List<BottomNavigationBarItem> bottomItem = [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.play_arrow,
            color: HexColor('#6d7381'),
          ),
          label: 'Listen',
          activeIcon: Icon(
            Icons.play_arrow,
            color: HexColor('#ffffff'),
          )),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: HexColor('#6d7381'),
          ),
          label: 'Favorite',
          activeIcon: Icon(
            Icons.favorite,
            color: HexColor('#ffffff'),
          )),
    ];
    return bottomItem;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        primary: false,
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: HexColor('#182545'),
          selectedItemColor: HexColor('#ffffff'),
          unselectedItemColor: HexColor('#6d7381'),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: onTapTapped,
          items: getBottomNavBarList(),
        ),
      ),
    );
  }
}
