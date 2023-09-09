import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/menu/menu_items.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  void onItemTapped(BuildContext context, MenuItem item) {
    context.goNamed(item.link);
  }

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;

    switch(location) {
      case '/':
        return 0;
        /*
      case '/exercises_pending_view':
        return 1;*/
      case '/messages_view':
        return 1;
      case '/turns_view':
        return 2;
      default: 
        return 0;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, appMenuItems[value]),
      items: [
        ...appMenuItems.map((item) =>  BottomNavigationBarItem(
                icon: Icon(item.icon, color: item.color, size: 35,),
                label: '',
              ))
      ]);
  }
}