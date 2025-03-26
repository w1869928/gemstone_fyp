import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemstone_fyp/Screens/Favourites_Page.dart';
import 'package:gemstone_fyp/Screens/HomePage.dart';
import 'package:gemstone_fyp/Screens/ViewUser_Page.dart';
import 'package:gemstone_fyp/Screens/classify_page.dart';
import 'package:gemstone_fyp/Screens/forgot_page.dart';
import 'package:gemstone_fyp/Screens/more_page.dart';

import '../Themes/color_palette.dart';
import '../Widgets/image_icon_builder.dart';

class LayoutScreen extends StatefulWidget {
  final int pageIndex;// page number initial is 0
  const LayoutScreen({super.key, required this.pageIndex});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;// handling page transmission

  //initial page setup
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  //function when icon tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;// updating the the page
    });
    _pageController.jumpToPage(index);//move to corresponding page
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
        children: const [
          MyHomePage(),
          ClassifyPage(),
          FavouritesPage(),
          MorePage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const ImageIconBuilder(
                image: 'assets/icons/home.png',
                isSelected: true,
              )
                  : const ImageIconBuilder(
                image: 'assets/icons/home-outline.png',
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const ImageIconBuilder(
                image: 'assets/icons/camera.png',
                isSelected: true,
              )
                  : const ImageIconBuilder(
                image: 'assets/icons/camera-outline.png',
              ),
              label: 'Classify',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? const ImageIconBuilder(
                image: 'assets/icons/favourite.png',
                isSelected: true,
              )
                  : const ImageIconBuilder(
                image: 'assets/icons/favorite-outline.png',
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? const ImageIconBuilder(
                image: 'assets/icons/more-outline.png',
                isSelected: true,
              )
                  : const ImageIconBuilder(
                image: 'assets/icons/more.png',
              ),
              label: 'more',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorPalette.primaryBlue,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}