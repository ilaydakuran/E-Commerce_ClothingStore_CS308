import 'package:cs308_ecommerce/routes/profile.dart';
import 'package:cs308_ecommerce/routes/search.dart';
import 'package:cs308_ecommerce/routes/catagories.dart';
import 'package:cs308_ecommerce/routes/shoppingbag.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:flutter/material.dart';

class bottombar extends StatefulWidget {
  @override
  _appbarState createState() => _appbarState();
}

class _appbarState extends State<bottombar> {
  int _pageNum = 0;
  PageController pControl;
  @override
  void initState() {
    super.initState();
    pControl =PageController();
  }
  @override
  void dispose() {
    pControl.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (openPage) {
          setState(() {
            _pageNum = openPage;
          });
        },
        controller: pControl,
        children: [
          search(),
          catsearch(),
          Profile(),
          //Shoppingbag(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageNum,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.menu),title: Text('Categories')),
          BottomNavigationBarItem(icon: Icon(Icons.person),title: Text('Profile')),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),title: Text('Shopping bag')),

        ],
        onTap: (selected){
          setState(() {
            pControl.jumpToPage(selected);
          });
        },
      ),
    );
  }
}