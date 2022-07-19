// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:kim_test/screens/calender_screen.dart';



class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  HomeNavState createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  int selectedIndex = 1;
  List screens = [
    SizedBox(),
    CalenderView(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];
  Widget navBarItem(IconData icon,int index,){
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
            decoration:  BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: selectedIndex==index ?  Colors.blue:Colors.transparent,
                    width: 3.0,
                  ),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon,color: selectedIndex==index ?Colors.blue:  Colors.grey,),
            )
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Row(

          children: [
            navBarItem(Icons.home,0),
            navBarItem(Icons.calendar_month,1),
            navBarItem(Icons.camera,3),
            navBarItem(Icons.search,4),
            navBarItem(Icons.shopping_bag_sharp,5),
          ],
        ),
        body:screens[selectedIndex],
      ),
    );
  }
}


